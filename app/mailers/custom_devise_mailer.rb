class CustomDeviseMailer < DeviseMailer

  include ApplicationHelper

  def confirmation_instructions(record, token, opts={})
    @site_name = t('app.common.name')
    @user = record
    super
  end
end
