class RootController < ApplicationController
  include ApplicationHelper
  # before_action :set_page_content, only: [:index, :faq, :privacy_policy, :terms_of_use]

  def index
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


    places = Place.by_filter(filter, current_user)#.limit(10)

    gon.labels.merge!({
      result: t('.result', count: 1),
      results: t('.result', count: 2),
      show_all: t('.alt.show_all'),
      show_favorite: t('.alt.show_favorite'),
      not_found: t('.not_found'),
      alt: t('app.common.alt', alt: '%alt'),
      by: t('app.common.by'),
      picked_as_favorite: t('shared.picked_as_favorite'),
      overall_rating: t('shared.overall_rating_js'),
      services: services_clean,
      view_all_provider_places: t('shared.view_all_provider_places'),
      view_place_details: t('shared.view_place_details'),
      view_all_services: t('shared.view_all_services')
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
        services: place.service_ids
      }
    }

    respond_to do |format|
      format.html { render locals: { filter: filter } }
      format.json { render json: { result: result, result_count: places.count() } }
    end
  end

  def about
    render :action => 'index', locals: { dialog_trigger_type: :about }
  end

  def contact
    render :action => 'index', locals: { dialog_trigger_type: :contact }
  end

  def faq
    @class = "faq"
    gon.is_faq_page = true
    @page_content = PageContent.by_name('faq')
  end

  def privacy_policy
    @class = "privacy_policy"
    @page_content = PageContent.by_name('privacy_policy')
  end

  def terms_of_use
    @class = "terms_of_use"
    @page_content = PageContent.by_name('terms_of_use')
  end

  def place
    pars = place_params.inject({}) { |memo, (k, v)|
      key = k.to_sym
      v = true if v == 'true'
      v = false if v == 'false'
      memo[key] = v if key != :locale
      memo
    }

    place_id = pars[:id]
    item = Place.find_by(id: place_id)

    if item.nil?
      redirect_to root_path, flash: { error:  t('app.messages.not_found', obj: Place) }
      return
    end

    @has_place_report_dialog = true
    @place_report_href = place_path(id: item.id, a: 'report', v: '_v_')

    user_id = nil
    if user_signed_in?
      user_id = current_user.id

      is_favorite_place = FavoritePlace.is_favorite_place?(user_id, place_id)
      user_rate = PlaceRate.get_rate(user_id, place_id)
      is_ownership_requested = PlaceOwnership.requested?(user_id, place_id)
      is_report_requested = PlaceReport.requested?(user_id, place_id)
      @has_place_report_dialog = !is_report_requested

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
     Rails.logger.debug("-----------------------------------action--#{action}---value #{value}")

      if action == 'favorite'
        forward = set_flash(FavoritePlace.favorite(user_id, place_id, value))
      elsif action == 'rate'
        value = value.to_i if value.present? && value.is_number?
        if value >= 0 && value <= 5
          forward = set_flash(PlaceRate.rate(user_id, place_id, value))
        end
      elsif action == 'report' && !is_report_requested
        if value.present?
          forward = set_flash(PlaceReport.request_report(user_id, place_id, value))
        end
      elsif action == 'ownership' && !is_ownership_requested
        forward = set_flash(PlaceOwnership.request_ownership(user_id, place_id))
      end
    end

    forward = {} unless forward.present?

    gon.history = 'replace' if has_action

    gon.labels.merge!({
      add_to_favorite: t('.add_to_favorite'),
      remove_from_favorite: t('.remove_from_favorite'),
      ownership_under_consideration: t('.take_ownership_underway'),
      report_under_consideration: t('.report_underway')
    })
    gon.place_address = item.address

    respond_to do |format|
      format.html { render locals:
        {
          item: item,
          is_favorite_place: is_favorite_place,
          user_rate: user_rate,
          is_ownership_requested: is_ownership_requested,
          is_report_requested: is_report_requested
        }
      }
      format.json { render json: { flash: flash.to_hash }.merge(forward) }
    end

  end

  private

    def locals(values)
      render locals: values
    end

  def index_params
    params.permit(:what, :where, :rate, :favorite, :locale, :_, services: [], map: [])
  end
  def place_params
    params.permit(:id, :a, :v, :locale, :_)
  end
  # def set_page_content
  #   @about_page_content = PageContent.by_name('about')
  # end
end
