require 'sequel'

module Dannunzio
  module SQL

    module Connection

      class << self
        def create_connection
          @connection ||= Sequel.connect(connection_url)
        end

        def connection_url
          "sqlite://#{data_path}"
        end

        def data_path
          return @data_path if @data_path
          path = ENV["DANNUNZIO_DATA_PATH"] || "~/.dannunzio/pop3.db"
          @data_path = File.expand_path(path)
        end
      end

      def db
        @connection ||= create_connection
      end

      private

      def create_connection
        Connection.create_connection
      end

    end

  end
end
