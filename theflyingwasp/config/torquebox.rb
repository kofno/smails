TorqueBox.configure do

  queue '/queues/mail_sender' do
    create false
    processor TheFlyingWasp::MailSender
  end

end
