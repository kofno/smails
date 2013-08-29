require 'sequel'
require 'pathname'

module Dannunzio
  module SQL

    module Connection

      class << self
        def connection
          @connection ||= Sequel.connect(connection_url)
        end

        def connection_url
          "sqlite://#{data_path}"
        end

        def data_path
          @data_path ||= begin
            path = ENV["DANNUNZIO_DATA_PATH"] || "~/.dannunzio/pop3.db"
            @data_path = File.expand_path(path)
            Pathname.new(@data_path).parent.mkpath
            @data_path
          end
        end
      end

      def db
        @connection ||= create_connection
      end

      private

      def create_connection
        Connection.connection
      end

    end

  end
end
