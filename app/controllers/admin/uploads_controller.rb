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

        if flag
          flash[:success] = "#{assets_length} photos uploaded."
        else
          flash[:error] = "Something went wrong, try again later"
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
          flash[:success] = "#{assets_length} photos uploaded and waiting to be processed"
        else
          flash[:error] = "Error while uploading photos, please contact administration"
        end
      end
    else
      flash[:error] = "#{Place.human_name} #{t('errors.messages.not_found')}"
    end

    redirect_to :back
  end

  private

  # def set_gallery
  #   @gallery = Gallery.find(params[:gallery_id])
  # end

  # def add_more_images(new_images)
  #   images = @gallery.images # copy the old images
  #   images += new_images # concat old images with new ones
  #   @gallery.images = images # assign back
  # end

  # def create_params
  #   params.require(:assets_attributes)
  #   params.require(:upload).permit(:place_id, :image, "@original_filename", "@content_type", "@headers") # allow nested params as array
  # end
  def create_upload_params
    params.require(:upload).permit(:place_id)
  end
  def create_assets_params
    params.require(:assets_attributes).map do |m|
      ActionController::Parameters.new(m.to_hash).permit(:image, "@original_filename", "@content_type", "@headers")
    end
  end
end
