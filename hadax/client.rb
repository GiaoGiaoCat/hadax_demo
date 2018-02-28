require 'net/https'
require 'uri'
require 'json'
require 'digest/md5'
require 'base64'
require 'openssl'
require 'rack'

module Hadax
  class Client
    API_URL = 'https://api.huobi.pro/v1'.freeze

    attr_reader :access_key, :secret_key

    def initialize(access_key, secret_key)
      @uri = URI.parse "https://api.huobi.pro/"
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
      path = "/v1/account/accounts"
      request_method = "GET"
      params ={}
      json = util(path, params, request_method)
    end

    def util(path, params, request_method)
      h =  {
        "AccessKeyId"=>@access_key,
        "SignatureMethod"=>"HmacSHA256",
        "SignatureVersion"=>2,
        "Timestamp"=> Time.now.getutc.strftime("%Y-%m-%dT%H:%M:%S")
      }
      h = h.merge(params) if request_method == "GET"
      data = "#{request_method}\napi.huobi.pro\n#{path}\n#{Rack::Utils.build_query(hash_sort(h))}"
      h["Signature"] = sign(data)
      url = "https://api.huobi.pro#{path}?#{Rack::Utils.build_query(h)}"
      http = Net::HTTP.new(@uri.host, @uri.port)
      http.use_ssl = true
      begin
        JSON.parse http.send_request(request_method, url, JSON.dump(params),@header).body
      rescue Exception => e
        {"message" => 'error' ,"request_error" => e.message}
      end
    end

    def sign(data)
      Base64.encode64(OpenSSL::HMAC.digest('sha256', @secret_key, data)).gsub("\n","")
    end

    def hash_sort(ha)
      Hash[ha.sort_by{ |key, val| key }]
    end

    def place_order(order_type, symbol_pair, price, amount)
      data = package_data({ account_id: @account_id, amount: amount, price: price, symbol: symbol_pair, type: order_type })
      http_post(:place_order, data)
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
