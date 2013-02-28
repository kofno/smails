require 'spec_helper'

describe Pop3Client do

  let(:client) { 
    Pop3Client.new server:   'pop.gmail.com',
                   port:     995,
                   username: 'a.user@gmail.com',
                   password: 'sekrit',
                   ssl:      true
  }

  it 'retrieves each message and deletes it from the server' do
    client.should_receive(:start)
    client.should_receive(:empty?).and_return false
    client.should_receive(:delete_all)
    client.should_receive(:finish)

    client.messages {}
  end
  
  it 'does not even make the connection if no block is provided' do
    client.messages
  end

end
