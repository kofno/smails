TorqueBox.configure do

  queue '/queues/mail_lists' do
    processor MailReceiver
  end

  queue '/queues/mail_sender'
end
