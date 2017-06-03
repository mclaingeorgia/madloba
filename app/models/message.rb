class Message
  include ActiveModel::AttributeMethods
  attr_accessor :bcc, :subject, :message
end
