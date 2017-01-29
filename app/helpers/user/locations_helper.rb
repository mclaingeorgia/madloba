module User::LocationsHelper

  def adding_new?
    action_name == 'new' || action_name == 'create'
  end

end
