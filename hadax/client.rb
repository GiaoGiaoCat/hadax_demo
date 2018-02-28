require 'net/http'
require 'uri'
require 'json'
require 'digest/md5'
require 'base64'

module Hadax
  class Client
    API_URL = "https://api.huobi.pro/v1"

    attr :access_key, :secret_key

    def initialize(access_key, secret_key)
      @access_key = access_key
      @secret_key = secret_key
      @account_id = get_account_id
    end

    # TODO: 买入数量要根据自己现金决定
    def open_a_position(symbol_pair, price)
      place_order('buy-limit', symbol_pair, price, 100)
    end

    # TODO: 卖出数量要根据自己库存决定
    def close_a_position(symbol_pair, price)
      place_order('sell-limit', symbol_pair, price, 100)
    end

    private
      # TODO: get account_id by `GET /v1/account/accounts`.
      def get_account_id
        #...
      end

      # TODO: place an order by `POST /v1/order/orders/place`
      def place_order(order_type, symbol_pair, price, amount)
        puts 'place order'
        # ...
      end

      # TODO: 签名动作
      def sign
        # ...
      end
  end
end
