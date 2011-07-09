require 'blertr/notifier'
require 'net/smtp'

module Blertr
  class MailNotifier < Notifier
    def initialize
      super
      @names = ["mail", "email"]
    end

    def alert name, time
      username = options[:username]
      password = options[:password]
      receiver = options[:to]
      msg = message name, time
      smtp = Net::SMTP.new 'smtp.gmail.com', 587
      smtp.enable_starttls
      smtp.start('gmail.com', username, password, :login) do
        smtp.send_message(msg, "#{username}@gmail.com", receiver)
      end
    end

    def message name, time
      first_name = name.split(" ")[0]
      msg = "Subject: #{first_name} is done!\n"
      msg += "#{first_name} has completed.\nFull Command: #{name}\nTime Taken: #{time} seconds\n"
      msg
    end

    def can_alert?
      rtn = true
      rtn &= options[:username]
      rtn &= options[:password]
      rtn &= options[:to]
      rtn
    end
  end
end
