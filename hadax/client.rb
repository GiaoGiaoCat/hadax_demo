require 'net/https'
require 'uri'
require 'json'
require 'digest/md5'
require 'base64'
require 'openssl'
require 'rails/all'

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
      puts @account_id
      # place_order('buy-limit', symbol_pair, price, 10)
    end

    # TODO: 卖出数量要根据自己库存决定
    def close_a_position(symbol_pair, price)
      # place_order('sell-limit', symbol_pair, price, 10)
    end

    private

    def get_account_id
      data = package_data.merge({"Signature": 'some sign'})
      http_get(:accounts)
    end

    def place_order(order_type, symbol_pair, price, amount)
      data = package_data({ account_id: @account_id, amount: amount, price: price, symbol: symbol_pair, type: order_type })
      http_post(:place_order, data)
    end

    def sign(method: 'GET', action: '', params:)
      do_sign populate_signee(method: 'GET', action: '', params: params)
    end

    def populate_signee(method: 'GET', action: '', params: {})
      "#{method}\n" +
      "api.huobi.pro\n" +
      "#{action}\n" +
      sorted_params(method: method, params: params)
    end

    def do_sign(data = '')
      OpenSSL::HMAC.hexdigest("SHA256", secret_key, data)
    end

    def sorted_params(method: 'GET', params: {})
      # "AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2017-05-11T15%3A19%3A30&order-id=1234567890"
      base_params = {
        AccessKeyId: access_key,
        SignatureMethod: 'HmacSHA256',
        SignatureVersion: 2,
        Timestamp: URI.encode(Time.now.utc.strftime("%Y-%m-%d %H:%M:%S"))
      }
      if method == 'GET'
        base_params.merge(params).compact.sort.to_h.to_query.join('&')
      else
        base_params.compact.sort.to_h.join('&')
      end
    end

    def package_data(params = {})
      {
        "AccessKeyId": @access_key,
        "SignatureMethod": "HmacSHA256",
        "SignatureVersion": "2",
        "Timestamp": Time.now.getutc.strftime("%Y-%m-%dT%H:%M:%S")
      }.merge(params)
    end

    def http_get(action, data = nil)
      http, uri = set_http_client(action)
      request = Net::HTTP::Get.new(uri.request_uri, header)
      request.body = data.to_json
      response = http.request(request)
      response.body
    end

    def http_post(action, data = nil)
      http, uri = set_http_client(action)
      request = Net::HTTP::Post.new(uri.request_uri, header)
      request.body = data.to_json
      response = http.request(request)
      response.body
    end

    def set_http_client(action)
      uri = URI.parse(API_URL + api_path(action))
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      [http, uri]
    end

    def api_path(action)
      case action
      when :place_order then '/order/orders/place'
      when :accounts then '/account/accounts'
      end
    end

    def header
      {
        'Content-Type'=> 'application/json',
        'Accept' => 'application/json',
        'Accept-Language' => 'zh-CN',
        'User-Agent'=> 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36'
      }
    end
  end
end
