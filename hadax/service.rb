require_relative 'client'
module Hadax
  class Service
    attr :client, :status

    def initialize(access_key, secret_key)
      @client = Hadax::Client.new(access_key, secret_key)
      @status = 0
    end

    def open_a_position(symbol_pair, bid_price)
      @client.open_a_position(symbol_pair, bid_price)
      change_status(1)
    end

    def close_a_position(symbol_pair, ask_price)
      @client.close_a_position(symbol_pair, bid_price)
      change_status(0)
    end

    def can_open_a_position?
      status == 0
    end

    def can_close_a_position?
      status == 1
    end

    private

      def change_status(status)
        @status = status
      end
  end
end
