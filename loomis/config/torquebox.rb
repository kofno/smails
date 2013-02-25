TorqueBox.configure do

  queue '/queues/mail_lists' do
    create false
    processor MailReceiver
  end

  queue '/queues/mail_sender'
end
