class CustomDeviseMailer < DeviseMailer

  include ApplicationHelper

  def confirmation_instructions(record, token, opts={})
    @site_name = t('app.common.name2')
    @user = record
    super
  end
end
