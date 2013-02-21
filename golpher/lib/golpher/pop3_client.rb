require 'net/pop'

module Golpher

  class Pop3Client

    attr_reader :server, :port, :username, :password, :connection
    private     :server, :port, :username, :password, :connection

    def initialize options
      @username = options[:username] 
      @password = options[:password]
      @server   = options[:server]
      @port     = options[:port]

      @connection = Net::POP3.new(server, port)
      @connection.enable_ssl(OpenSSL::SSL::VERIFY_NONE) if options[:ssl]
    end

    def messages
      return unless block_given?

      connection.start username, password
      unless connection.mails.empty?
        connection.delete_all do |mail|
          yield mail.pop
        end
      end
    ensure
      connection.finish rescue nil
    end
  end

end
