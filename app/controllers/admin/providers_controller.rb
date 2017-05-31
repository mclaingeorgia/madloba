class Admin::ProvidersController < AdminController
  before_filter :authenticate_user!, except: [:send_message]
  before_filter { @model = Provider; }

  def index
    authorize @model
    @items = @model.sorted
  end

  def new
    authorize @model
    @item = @model.new
  end

  def create
    pars = strong_params
    redirect_default = pars.delete(:redirect_default) == 'true'
    item = @model.new(pars)
    item.users << current_user
    authorize item

    redirect_path = redirect_default ?
      manage_providers_path :
      manage_provider_profile_path(page: 'manage-providers')

    @item = item if redirect_default

    if item.save
      flash[:success] = t('app.messages.success_updated', obj: @model)
      redirect_to redirect_path
    else
      flash[:error] = format_messages(item)
      if redirect_default
        render action: "new"
      else
        render 'admin/provider_profile', locals: prepaire_provider_profile(true, :'manage-providers', nil, :new, item)
      end
    end
  end

  def edit
    @item = @model.find(params[:id])
    authorize @item
    @edit_associations = true
    gon.autocomplete = { users: manage_autocomplete_path(:users), places: manage_autocomplete_path(:places) }
  end

  def update
    pars = strong_params
    item = @model.find(params[:id])
    authorize item

    redirect_default = pars.delete(:redirect_default) == 'true'
    redirect_path = redirect_default ?
      manage_providers_path :
      manage_provider_profile_path(page: 'manage-providers')

    @item = item if redirect_default

    if item.update_attributes(pars)
      flash[:success] = t('app.messages.success_updated', obj: "#{@model.human} #{item.name}")
      redirect_to redirect_path
    else
      flash[:error] = format_messages(item)
      if redirect_default
        render action: "edit"
      else
        render 'admin/provider_profile', locals: prepaire_provider_profile(true, :'manage-providers', nil, :edit, item)
      end
    end
  end

  def destroy
    item = @model.find(params[:id])
    authorize item

    if item.update_attributes(deleted: true) && item.places.update_all(deleted: 2)
      flash[:success] =  t("app.messages.success_destroyed", obj: "#{@model.human} #{item.name}")
    else
      flash[:error] =  t('app.messages.fail_destroyed', obj: "#{@model.human} #{item.name}")
    end

    redirect_to :back
  end

  def restore
    item = @model.find(params[:id])
    authorize item

    if item.update_attributes(deleted: false) && item.places.where(deleted: 2).update_all(deleted: 0)
      flash[:success] =  t("app.messages.success_restored", obj: "#{@model.human} #{item.name}")
    else
      flash[:error] =  t('app.messages.fail_restored', obj: "#{@model.human} #{item.name}")
    end

    redirect_to :back
  end

  def send_message
    authorize @model

    pars = params.permit(:authenticity_token, :locale, :'g-recaptcha-response', {:message => [:sender, :email, :text]})
    message = pars[:message]
    verification = verify_message(message)

    # flash = { message: 'test message' }
    respond_to do |format|
      format.html do
        redirect_to :back
      end
    end
  end

  private

    def verify_message(message)
      errors = []
      if verify_recaptcha
        errors << { type: :error, text: t('.sender_missing') } if message[:sender].nil?
        errors << { type: :error, text: t('.improper_email_') } if /\A[^@]+@[^@]+\z/.match(message[:email]).present?
        errors << { type: :error, text: t('.text_missing') } if message[:text].nil?
      else
        errors << { type: :error, text: t('.skynet_detected') } if message[:sender].nil?
      end
      errors.present? ? errors : true
    end

    def strong_params
      params.require(:provider).permit(*@model.globalize_attribute_names, :redirect_default)
    end
end
