class RootController < ApplicationController
  include ApplicationHelper
  # before_action :set_page_content, only: [:index, :faq, :privacy_policy, :terms_of_use]

  def index
    index_prepaire
  end

  def about
    authorize :root
    index_prepaire
  end

  def contact
    authorize :root
    index_prepaire
  end

  def faq
    authorize :root
    @class = "faq"
    gon.is_faq_page = true
    @page_content = PageContent.by_name('faq')
  end

  def privacy_policy
    authorize :root
    @class = "privacy_policy"
    @page_content = PageContent.by_name('privacy_policy')
  end

  def terms_of_use
    authorize :root
    @class = "terms_of_use"
    @page_content = PageContent.by_name('terms_of_use')
  end

  def place
    authorize :root
    @has_slideshow = true

    pars = place_params.inject({}) { |memo, (k, v)|
      key = k.to_sym
      v = true if v == 'true'
      v = false if v == 'false'
      memo[key] = v if key != :locale
      memo
    }

    place_id = pars[:id]
    item = Place.only_active.only_published.find_by(id: place_id)

    if item.nil?
      redirect_to root_path, flash: { error:  t('errors.not_found', obj: Place) }
      return
    end

    @has_place_report_dialog = true
    @place_report_href = place_path(id: item.id, a: 'report', v: '_v_')
    @place_name = item.name

    user_id = nil
    if user_signed_in?
      user_id = current_user.id

      is_favorite_place = FavoritePlace.is_favorite_place?(user_id, place_id)
      user_rate = PlaceRate.get_rate(user_id, place_id)
      is_ownership_requested = PlaceOwnership.requested?(user_id, place_id)

    end


    action = pars[:a]
    value = pars[:v]
    has_action = false

    if ['favorite', 'rate', 'report', 'ownership'].index(action)
      if !user_signed_in?
        respond_to do |format|
          set_user_return_to
          format.html { redirect_to new_user_session_path, status: :unauthorized }
          format.json { render json: { trigger: 'sign_in' }, status: :unauthorized }
        end
        return
      else
        has_action = true
      end

      if action == 'favorite'
        forward = set_flash(FavoritePlace.favorite(user_id, place_id, value))
      elsif action == 'rate'
        value = value.to_i if value.present? && value.is_number?
        if value >= 0 && value <= 5
          forward = set_flash(PlaceRate.rate(user_id, place_id, value))
        end
      elsif action == 'report'# && !is_report_requested
        if value.present?
          forward = set_flash(PlaceReport.request_report(user_id, place_id, value))
        end
      elsif action == 'ownership'
        has_action = false
        if current_user.user?
          flash[:error] = t('messages.provider_role_required')
          forward = { redirect_to: manage_user_profile_path }#set_flash(PlaceOwnership.request_ownership(user_id, place_id))
        elsif current_user.at_least_provider?
          forward = { dialog: { name: 'place_ownership', html: place_ownership_dialog(item) } }#set_flash(PlaceOwnership.request_ownership(user_id, place_id))
        end
      end
    end

    forward = {} unless forward.present?

    gon.history = 'replace' if has_action

    gon.labels.merge!({
      favorite: t('shared.favorite'),
      unfavorite: t('shared.unfavorite'),
      ownership_under_consideration: t('.take_ownership_underway'),
    })
    gon.place_address = item.address

    respond_to do |format|
      format.html { render locals:
        {
          item: item,
          is_favorite_place: is_favorite_place,
          user_rate: user_rate,
          is_ownership_requested: is_ownership_requested#,
          # is_report_requested: is_report_requested
        }
      }
      format.json { render json: { flash: flash.to_hash }.merge(forward) }
    end

  end

  def create_place_ownership

  end
  private

    def place_ownership_dialog(place)
      render_to_string partial: 'place_ownership_dialog', locals: { place: place }
    end
    def index_prepaire
      authorize :root
      @class = 'loader'

      pars = index_params.inject({}) { |memo, (k, v)|
        key = k.to_sym
        v = true if v == 'true'
        v = false if v == 'false'
        memo[key] = v if key != :locale
        memo
      }

      tmp = pars[:services]
      pars[:services] = (tmp.present? && tmp.kind_of?(Array) && tmp.length >= 1) ? tmp.map(&:to_i) : []

      tmp = pars[:rate]
      tmp = tmp.to_i if tmp.present? && tmp.is_number?
      pars[:rate] = (tmp.present? && !(tmp > 0 && tmp < 5) ? 0 : tmp)

      tmp = pars[:favorite]
      pars[:favorite] = false if tmp.present? && tmp != true && tmp != false

      tmp = pars[:map]
      pars[:map] = (tmp.present? && tmp.kind_of?(Array) && tmp.length == 4) ? tmp.map(&:to_f) : []

      filter = {
        what: nil,
        where: nil,
        services: nil, # []
        rate: nil,
        favorite: nil,
        map: nil
      }.merge(pars)

      services_clean = Service.sorted.pluck(:id, :name, :icon)
      @services = services_clean
        .each_with_index.map{|m,i| m.push(i+1, (filter[:services].index(m[0]).nil? ? false : true)) }

      if filter[:favorite] && !user_signed_in?
        respond_to do |format|
          set_user_return_to
          format.html { redirect_to new_user_session_path, status: :unauthorized }
          format.json { render json: { trigger: 'sign_in' }, status: :unauthorized }
        end
        return
      end


      places = Place.filter(filter, current_user).limit(10)

      gon.labels.merge!({
        result: t('root.index.result', count: 1),
        results: t('root.index.result', count: 2),
        show_all: t('root.index.alt.show_all'),
        show_favorite: t('root.index.alt.show_favorite'),
        not_found: t('root.index.not_found'),
        alt: t('app.common.alt', alt: '%alt'),
        by: t('app.common.by'),
        picked_as_favorite: t('shared.picked_as_favorite'),
        overall_rating: t('shared.overall_rating_js'),
        services: services_clean,
        view_all_provider_places: t('shared.view_all_provider_places'),
        view_place_details: t('shared.view_place_details'),
        view_all_services: t('shared.view_all_services'),
        view_all_service_places: t('shared.view_all_service_places')

      })
      gon.regions = Region.sorted.pluck(:id, :name)
      # gon.regions = {}
      # Region.sorted.pluck(:id, :name).each{|e|
      #   gon.regions[e[0]] = e[1]\
      # }

      result = {}
      places.each {|place|
        region_id = place.region_id
        result[region_id] = [] unless result[region_id].present?
        result[region_id] << {
          id: place.id,
          name: place.name,
          image: place.poster,
          path: place_path(id: place.id),
          rating: place.get_rating,
          provider: {
            name: place.provider.name
            },
          address: place.address,
          phone: place.phone,
          coordinates: [place.latitude, place.longitude],
          services: place.services.ids
        }
      }

      respond_to do |format|
        format.html { render action: :index, locals: { filter: filter  } }
        format.json { render json: { result: result, result_count: places.count() } }
      end
    end
    def locals(values)
      render locals: values
    end

    def index_params
      params.permit(:what, :where, :rate, :favorite, :locale, :_, services: [], map: [])
    end

    def place_params
      params.permit(:id, :a, :v, :locale, :_)
    end
end
