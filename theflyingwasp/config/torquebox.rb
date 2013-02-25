TorqueBox.configure do

  queue '/queues/mail_sender' do
    processor TheFlyingWasp::MailSender
  end

end
