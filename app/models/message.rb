class Message
  include ActiveModel::AttributeMethods
  attr_accessor :to, :bcc, :subject, :message
end
