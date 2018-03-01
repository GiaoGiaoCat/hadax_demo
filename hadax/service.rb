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

    def get_balance(account_id)
      @client.get("/v1/account/accounts/#{account_id}/balance")
    end

    def open_a_position(account_id, symbol_pair, bid_price, amount)
      params = {
        "account-id" => account_id,
        "amount" => amount,
        "price" => bid_price,
        "source" => "api",
        "symbol" => symbol_pair,
        "type" => "buy-limit"
      }
      puts "open_a_position"
      puts @client.post("/v1/order/orders/place", params)
      change_status(1)
    end

    def close_a_position(account_id, symbol_pair, ask_price, amount)
      params = {
        "account-id" => account_id,
        "amount" => amount,
        "price" => ask_price,
        "source" => "api",
        "symbol" => symbol_pair,
        "type" => "sell-limit"
      }
      puts "close_a_position"
      puts @client.post("/v1/order/orders/place", params)
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
