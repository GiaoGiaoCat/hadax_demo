require_relative 'client'
module Hadax
  class Service
    attr :client, :status

    def initialize(access_key, secret_key)
      @client = Hadax::Client.new(access_key, secret_key)
      @status = 0
    end

    def get_account
      @client.get("/v1/account/accounts")
    end

    # TODO: 买入数量要根据自己现金决定
    def open_a_position(account_id, symbol_pair, bid_price)
      # @client.open_a_position(symbol_pair, bid_price)
      params = {
        "account-id" => account_id,
        "amount" => 1,
        "price" => bid_price,
        "source" => "api",
        "symbol" => symbol_pair,
        "type" => "buy-limit"
      }
      puts @client.post("/v1/order/orders/place", params)
      change_status(1)
    end

    # TODO: 卖出数量要根据自己库存决定
    def close_a_position(symbol_pair, ask_price)
      # @client.close_a_position(symbol_pair, ask_price)
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
