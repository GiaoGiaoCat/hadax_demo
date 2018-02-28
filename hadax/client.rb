require 'net/https'
require 'uri'
require 'json'
require 'digest/md5'
require 'base64'

module Hadax
  class Client
    API_URL = 'https://api.huobi.pro/v1'.freeze

    attr_reader :access_key, :secret_key

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
      # ...
      # data = package_data(params)
      # http_get(action, data)
    end

    # TODO: place an order by `POST /v1/order/orders/place`
    def place_order(order_type, symbol_pair, price, amount)
      data = package_data({ amount: amount, price: price, symbol: symbol_pair, type: order_type })
      http_post(:place_order, data)
    end

    # TODO: 签名动作
    def sign
      # ...
    end

    def package_data(params)
      { 'account-id': @account_id }.merge(params)
    end

    # TODO: some code looks like `http_post`.
    def http_get(action, data)
      # ...
    end

    def http_post(action, data)
      http, uri = set_http_client(action)
      req = Net::HTTP::Post.new(uri.path, initheader)
      req.body = data.to_json
      res = http.request(req)
      res.body
    end

    def initheader
      { 'Content-Type' => 'application/json' }
    end

    def set_http_client(action)
      path =
        case action
        when :place_order then '/order/orders/place'
        when :account then '/account/accounts'
        end
      uri = URI.parse(host + path)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      [http, uri]
    end
  end
end
