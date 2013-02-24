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

    def messages &block
      return unless block_given?

      start
      delete_all &block unless empty?
    ensure
      finish
    end

    private

    def start
      connection.start username, password
    end

    def delete_all &block
      connection.delete_all do |mail|
        block.call mail.pop
      end
    end

    def finish
      connection.finish rescue nil
    end

    def empty?
      connection.mail.empty?
    end
  end

end
