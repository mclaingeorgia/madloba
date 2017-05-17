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
    # Rails.logger.debug("--------------------------------------------#{filter} #{@services}")

    places = Place.by_filter(filter).limit(10)
     Rails.logger.debug("--------------------------------------------#{places.length}")

    # gon.filter = filter
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
      services: services_clean
    })
    missing_path = ActionController::Base.helpers.asset_path("png/missing.png")
    result = []
    places.each {|place|
      result << {
        id: place.id,
        name: place.name,
        image: missing_path,
        path: place_path(id: place.id),
        rating: place.rating || 0,
        provider: {
          name: place.provider.name
          },
        address: place.address,
        phone: place.phone,
        coordinates: [place.latitude, place.longitude],
        services: place.service_ids
        #html: (render_to_string partial: 'shared/place', locals: { place: place }),
        # location: {
        #   id: place.id,
        #   name: place.name,
        #   coordinates: [place.latitude, place.longitude]
        # }
      }
    }



    respond_to do |format|
      format.html { render locals: { filter: filter } }
      format.json { render json: { result: result } }
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
    id = params[:id]
    item = Place.authorized_by_id(id)

    if item.present?
      locals({
        item: item
      })
    else
       Rails.logger.debug("--------------------------------------------should not be here")
      redirect_to root_path, flash: { error:  t('app.messages.not_found', obj: Place) }
    end
  end

  private

    def locals(values)
      render locals: values
    end

  def index_params
    params.permit(:what, :where, :rate, :favorite, :locale, services: [], map: [])
  end
  # def set_page_content
  #   @about_page_content = PageContent.by_name('about')
  # end
end
