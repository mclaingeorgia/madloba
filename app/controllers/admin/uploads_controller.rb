class Admin::UploadsController < AdminController
  before_filter :authenticate_user!
  before_filter { @model = Upload; }

  def create
    upload_pars = create_upload_params
    assets_pars = create_assets_params

    p = Place.find(upload_pars[:place_id])

    if p.present?
      if p.provider.users.include?(current_user)
        assets_pars.map do |m|
          m[:owner_id] = p.id
          m[:owner_type] = 1
        end

        flag = true
        assets_length = 0
        ActiveRecord::Base.transaction do
          assets = Asset.create(assets_pars)
          flag = false if !assets.present?
          assets_length = assets.length
        end

    # n_photo_uploaded:
    #   one: "Photo uploaded."
    #   other: "%{n} photos uploaded."
    # n_photo_uploaded_and_pending:
    #   one: "Photo uploaded and waiting to be processed"
    #   other: "%{n} photos uploaded and waiting to be processed"
    # uploader_failed: "Error while uploading photos, please contact administration"


        if flag
          flash[:success] = t('messages.n_photo_uploaded', n: assets_length, count: assets_length)
        else
          flash[:error] = t('errors.try_again')
        end


      else

        assets_pars.map do |m|
          m[:owner_id] = p.id
          m[:owner_type] = 2
        end

        flag = true
        assets_length = 0
        ActiveRecord::Base.transaction do
          assets = Asset.create(assets_pars)
          flag = false if !assets.present?
          assets_length = assets.length
          assets.each {|asset|
            if !@model.create(upload_pars.merge({user_id: current_user.id, asset_id: asset.id}))
              flag = false
              raise ActiveRecord::Rollback
            end
          }
        end
        if flag
          flash[:success] = t('messages.n_photo_uploaded_and_pending', n: assets_length, count: assets_length)
        else
          flash[:error] = t('messages.uploader_failed')
        end
      end
    else
      flash[:error] = "#{Place.human_name} #{t('errors.messages.not_found')}"
    end

    redirect_to :back
  end

  def upload_state_update
    pars = upload_state_params
    item = @model.find(pars[:id])
    state = ['accept', 'decline'].index(pars[:state])+1
    stated = state == 'accept' ? 'accepted' : 'declined'
    if current_user.providers.includes(:places).where(places: {id: item.place_id}).count()
      if item.processed == state
        flash.now[:success] =  t('app.messages.state_already_set', obj: item.place.name)
      elsif item.update_attributes(processed: state, processed_by: current_user.id)
        flash.now[:success] =  t("app.messages.#{stated}", obj:  item.place.name)
        forward = { moderate: { type: :upload,  id: item.id, state: pars[:state] } }
      else
        flash.now[:error] =  t('app.messages.fail_updated_state', obj:  item.place.name)
      end

    else
      flash.now[:error] =  t('app.messages.fail_updated_state', obj:  item.place.name)
    end

    forward = {} unless forward.present?
    respond_to do |format|
      format.html { redirect_to manage_provider_profile_path(page: 'moderate-photos') }
      format.json { render json: { flash: flash.to_hash }.merge(forward) }
    end
  end
  private
    def create_upload_params
      params.require(:upload).permit(:place_id)
    end
    def create_assets_params
      params.require(:assets_attributes).map do |m|
        ActionController::Parameters.new(m.to_hash).permit(:image, "@original_filename", "@content_type", "@headers")
      end
    end

    def upload_state_params
      params.permit(:id, :state, :locale)
    end
end
