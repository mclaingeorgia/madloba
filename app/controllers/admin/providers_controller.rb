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
    authorize item

    redirect_path = redirect_default ?
      manage_providers_path :
      manage_provider_profile_path(page: 'manage-providers')

    @item = item if redirect_default
    item.user = current_user

    if item.save
      item.users << current_user
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
    gon.labels = {
      search_placeholder: t('admin.shared.search_assign_placeholder'),
      are_you_sure:  t('shared.are_you_sure')
    }
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

    pars = params.permit(:id, :authenticity_token, :locale, :'g-recaptcha-response', {:message => [:sender, :email, :text]})
    msg = pars[:message]
    verification = verify_message(msg)
    if verification == true
      place = Place.find(pars[:id])
      if place.emails.present?
        message = Message.new
        message.bcc = place.emails.join(';')
        message.subject = "#{I18n.t('app.common.name')} - #{I18n.t('notification.contact.subject')}"
        message.message = { name: msg[:sender], email: msg[:email], text: msg[:text] }
        ApplicationMailer.send_contact_message(message).deliver_now
        flash[:success] = I18n.t('app.messages.contact_send_success')
      else
        flash[:error] = I18n.t('errors.not_found')
      end
    else
      set_flash({ type: :error, text: verification.map{|m| m[:text] }.join('<br>').html_safe}, false)
    end
  rescue Exception => e
    flash[:error] = I18n.t('app.messages.contact_send_fail')
    Rails.logger.debug("--------------------------------------------#{e}") # only dev
  ensure
    redirect_to :back
  end

  def assign_user
    provider = Provider.find_by(id: params[:id])
    user = User.find_by(id: params[:user_id])
    authorize provider

    flag = false
    if provider.present? && user.present? && !provider.users.include?(user)
      provider.users << user
      flag = provider.users.include?(user)
    end

    forward = {}
    if flag
      forward = {
        refresh: {
          type: :assign,
          action: :add,
          target: :users,
          to: [user.id, user.name, manage_unassign_user_from_provider_path(provider.id, user.id)]
        }
      }
      flash.now[:success] = t('messages.assign_provider_to_success', child: User.human, child_name: user.name, name: provider.name)
    else
      flash.now[:error] = t('messages.assign_provider_to_failed', child: User.human.downcase)
    end
    render json:  { flash: flash.to_hash }.merge(forward)
  end

  def unassign_user
    provider = Provider.find_by(id: params[:id])
    user = User.find_by(id: params[:user_id])
    authorize provider

    flag = false
    if provider.present? && user.present? && provider.users.include?(user)
      provider.users.delete(user)
      flag = !provider.users.include?(user)
    end

    forward = {}
    if flag
      forward = {
        refresh: {
          type: :assign,
          action: :delete,
          target: :users,
          to: user.id
        }
      }
      flash.now[:success] = t('messages.unassign_provider_to_success', child: User.human, child_name: user.name, name: provider.name)
    else
      flash.now[:error] = t('messages.unassign_provider_to_failed', child: User.human.downcase)
    end
    render json:  { flash: flash.to_hash }.merge(forward)
  end

  def assign_place
    provider = Provider.find_by(id: params[:id])
    place = Place.find_by(id: params[:place_id])
    authorize provider

    flag = false
    if provider.present? && place.present? && !provider.places.include?(place)
      place.provider.places.delete(place)
      provider.places << place
      flag = provider.places.include?(place)
    end

    forward = {}
    if flag
      forward = {
        refresh: {
          type: :assign,
          action: :add,
          target: :places,
          to: [place.id, place.name, manage_unassign_place_from_provider_path(provider.id, place.id)]
        }
      }
      flash.now[:success] = t('messages.assign_provider_to_success', child: Place.human, child_name: place.name, name: provider.name)
    else
      flash.now[:error] = t('messages.assign_provider_to_failed', child: Place.human.downcase)
    end
    render json:  { flash: flash.to_hash }.merge(forward)
  end

  def unassign_place
    provider = Provider.find_by(id: params[:id])
    place = Place.find_by(id: params[:place_id])
    authorize provider

    flag = false
    if provider.present? && place.present? && provider.places.include?(place)
      provider.places.delete(place)
      Provider.unknown.places << place
      flag = !provider.places.include?(place)
    end

    forward = {}
    if flag
      forward = {
        refresh: {
          type: :assign,
          action: :delete,
          target: :places,
          to: place.id
        }
      }
      flash.now[:success] = t('messages.unassign_provider_to_success', child: Place.human, child_name: place.name, name: provider.name)
    else
      flash.now[:error] = t('messages.unassign_provider_to_failed', child: Place.human.downcase)
    end
    render json:  { flash: flash.to_hash }.merge(forward)
  end

  private

    def verify_message(message)
      errors = []
      if verify_recaptcha
        errors << { type: :error, text: t('notification.contact.errors.sender_missing') } if message[:sender].blank?
        errors << { type: :error, text: t('notification.contact.errors.improper_email') } unless /\A[^@]+@[^@]+\z/.match(message[:email])
        errors << { type: :error, text: t('notification.contact.errors.text_missing') } if message[:text].blank?
      else
        errors << { type: :error, text: t('notification.contact.errors.skynet_detected') }
      end
      errors.present? ? errors : true
    end

    def strong_params
      params.require(:provider).permit(*@model.globalize_attribute_names, :redirect_default)
    end
end
