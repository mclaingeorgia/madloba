class Admin::UsersController < AdminController
  include ApplicationHelper

  before_action :authenticate_user!
  before_filter { @model = User; }

  def index
    authorize @model
    @items = @model.sorted
     # Rails.logger.debug("------------------------------------#{@model.sorted.length}-------#{@model.all.length}-#{@items.length}")
  end

  def new
    authorize @model
    @item = @model.new
  end

  def edit
    @item = @model.find(params[:id])
    authorize @item
  end

  def create
    @item = @model.new(strong_params)
    authorize item

    if item.save
      flash[:success] = t('app.messages.success_updated', obj: @model)
      redirect_to manage_users_path
    else
      flash[:error] = format_messages(item)
      render action: "new"
    end
  end

  def update
    pars = strong_params
    redirect_default = pars.delete(:redirect_default) == 'true'
    item = redirect_default ? @model.find(params[:id]) : current_user
    authorize item

    redirect_path = redirect_default ?
      manage_users_path :
      manage_user_profile_path(page: 'manage-profile')

    with_password = true
    if pars[:password].blank?
      pars.delete(:password)
      pars.delete(:password_confirmation)
      with_password = false
    end

    @item = item if redirect_default

    respond_to do |format|
      if item.update_attributes(pars) # with_password ? item.update_with_password(pars) :
        sign_in item, bypass: true if with_password
        flash[:success] = t('app.messages.success_updated', obj: "#{@model.human} #{item.name}")
        format.html { redirect_to redirect_path }
        format.json { render json: { flash: flash.to_hash } }
      else
        flash[:error] = format_messages(item)
        if redirect_default
          format.html { render action: "edit" }
          format.json { render json: { flash: flash.to_hash } }
        else
          format.html { render 'admin/user_profile', locals: prepaire_user_profile(true, :'manage-profile', nil, :edit, item) }
          format.json { render json: { flash: flash.to_hash } }
        end
      end
    end


    # if (current_user.is_admin_or_super_admin)
    #   @user = User.find(params[:id])
    # else
    #   @user = current_user
    # end
    # authorize @user

    # old_role = @user.role


    # if (current_user.is_admin_or_super_admin)
    #   if @user.update(strong_params)
    #     flash[:user] = @user.email

    #     # if the user was promoted
    #     if (old_role == 'user' && @user.role != 'user') || (old_role == 'admin' && @user.role == 'super_admin')
    #       recipient_info = {email: @user.email, name: @user.first_name, role: @user.role}
    #       UserMailer.notify_user_is_admin(recipient_info)
    #       # UserMailer.delay.notify_user_is_admin(recipient_info)
    #     end

    #     redirect_to admin_profile_path
    #   else
    #     render 'user'
    #   end
    # else
    #   if @user.update_with_password(strong_params)
    #     sign_in @user, :bypass => true
    #     flash[:user] = @user.email
    #     redirect_to user_manageprofile_path
    #   else
    #     render 'user'
    #   end
    # end

  end

  def destroy
    item = @model.find(params[:id])
    authorize item

    if item.update_attributes(deleted: true)
      flash[:success] =  t("app.messages.success_destroyed", obj: "#{@model.human} #{item.name}")
    else
      flash[:error] =  t('app.messages.fail_destroyed', obj: "#{@model.human} #{item.name}")
    end

    redirect_to :back
  end

  def restore
    item = @model.find(params[:id])
    authorize item

    if item.update_attributes(deleted: false)
      flash[:success] =  t("app.messages.success_restored", obj: "#{@model.human} #{item.name}")
    else
      flash[:error] =  t('app.messages.fail_restored', obj: "#{@model.human} #{item.name}")
    end

    redirect_to :back
  end

  private

    def strong_params
      params.require(:user).permit(:first_name, :first_name_en, :first_name_ka,
                                   :last_name, :last_name_en, :last_name_ka,
                                   :email, :role, :password, :password_confirmation, :current_password, :is_service_provider, :has_agreed, :redirect_default)
    end

end
