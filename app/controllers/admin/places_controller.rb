class Admin::PlacesController < AdminController
  before_filter :authenticate_user!, except: [:show]
  # before_action :authenticate_user!
  # authorize_resource
  before_filter { @model = Place; }

  def index
    @items = @model.sorted

    respond_to do |format|
      format.html
    end
  end

  def show
    @item = @model.find(params[:id])

    respond_to do |format|
      format.html
      # format.json { render json: @item }
    end
  end

  def new
    @item = @model.new
    @item.assets.build(owner_type: 1)

    respond_to do |format|
      format.html
    end
  end

  def create
    @item = @model.new(pars)

    respond_to do |format|
      if @item.save
        format.html do
          redirect_to manage_place_path, flash: {
            success:  t('app.messages.success_updated', obj: @model) }
        end
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
    @item = @model.find(params[:id])
    @item.assets.new(owner_type: 1)
  end

  def update
     Rails.logger.debug("-------------------------------place update-------------#{pars}")

    @item = @model.find(params[:id])
    respond_to do |format|
      if @item.update_attributes(pars)
        flash[:success] = t('app.messages.success_updated', obj: @model)
        format.html do
          #redirect_to manage_provider_profile_path(page: 'manage-places')
          redirect_to manage_provider_profile_path(page: 'manage-places')
        end
        format.json { render json: { flash: flash.to_hash, remove_asset: pars[:assets_attributes][:id] } }
      else


   l = {
      providers: Provider.by_user(current_user.id),
      current_page: :'manage-places',
      action: :edit,
      item: @item
    }
           @is_admin = true

        @class = 'provider_profile'

    @is_admin_profile_page = false

         Rails.logger.debug("--------------------------------------------#{@item.errors.inspect}")
        flash[:error] = t('app.messages.fail_updated', obj: @model)
        format.html do
          render 'admin/provider_profile', locals: l

          # redirect_to manage_provider_profile_path(page: 'manage-places', id: @item.id, edit: :edit)
        end
        format.json { render json: { flash: flash.to_hash } }
      end
    end
  end

  def destroy
    @item = @model.find(params[:id])
    # @item.destroy

    respond_to do |format|
      format.html do
        redirect_to manage_provider_profile_path(page: 'manage-places'), flash: {
          success:  t('app.messages.success_destroyed',
                      obj: @model),
          notice: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Enim, officiis?',
                    error: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Soluta, voluptas, ipsa.',
                    alert: 'Lorem ipsum dolor.'
        }
      end
      # format.json { head :no_content }
    end
  end
  # flash message type test
  # def destroy
  #   @item = @model.find(params[:id])
  #   #@item.destroy

  #   respond_to do |format|
  #     format.html do
  #       redirect_to admin_provider_path(tab: 'manage-places'), flash: {
  #         success:  t('app.messages.success_destroyed',
  #                     obj: t('activerecord.models.provider.one')),
  #         notice: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Enim, officiis?',
  #         error: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Soluta, voluptas, ipsa.',
  #         alert: 'Lorem ipsum dolor.'
  #       }
  #     end
  #     format.json { head :no_content }
  #   end
  # end
  private

  def pars
    permitted = Place.globalize_attribute_names + [:website, :postal_code, :region_id, :latitude, :longitude, :poster_id, emails: [], phones: [], service_ids: [],
      assets_attributes: ["@original_filename", "@content_type", "@headers", "_destroy", "id", "image"]]
    #
    #assets:  [ "@original_filename", "@content_type", "@headers", "_destroy", "id", "image"],
    params.require(:place).permit(*permitted)
  end
end




  # # GET /projects/1/edit
  # def edit
  #     @project.screenshots.new
  # end

  # # POST /projects
  # # POST /projects.json
  # def create
  #   @project = Project.new(project_params)

  #   respond_to do |format|
  #     if @project.save
  #       if params[:screenshots_attributes]
  #         params[:screenshots_attributes].each do |screenshot|
  #           @project.screenshots.create(image: screenshot[:image])
  #         end
  #       end
  #       format.html { redirect_to @project, notice: 'Project was successfully created.' }
  #       format.json { render :show, status: :created, location: @project }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @project.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PATCH/PUT /projects/1
  # # PATCH/PUT /projects/1.json
  # def update
  #   respond_to do |format|
  #     if @project.update(project_params)
  #       if params[:screenshots_attributes]
  #         params[:screenshots_attributes].each do |screenshot|
  #           @project.screenshots.create(image: screenshot[:image])
  #         end
  #       end
  #       format.html { redirect_to @project, notice: 'Project was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @project }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @project.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /projects/1
  # # DELETE /projects/1.json
  # def destroy
  #   @project.destroy
  #   respond_to do |format|
  #     format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_project
  #     @project = Project.find(params[:id])
  #   end

  #   # Never trust parameters from the scary internet, only allow the white list through.
  #   def project_params
  #     params.require(:project).permit(:title, :description, :screenshots_attributes => [:image])
  #   end
