require 'net/https'
require 'uri'
require 'json'
require 'openssl'
require 'rack'

require_relative 'sign'

module Hadax
  class Client
    API_SERVER = "api.huobi.pro"

    attr_reader :access_key, :secret_key

    def initialize(access_key, secret_key)
      @access_key = access_key
      @secret_key = secret_key
    end

    def get(path, params = {})
      do_get(path, params)
    end

    def post(path, params = {})
      do_post(path, params)
    end

    private
      def do_get(path, params = {})
        uri = build_url_with_params("GET", path, params)
        response = do_http(uri, Net::HTTP::Get.new(uri.request_uri))
        response.body
      end

      def do_post(path, params = {})
        uri = build_url_with_params("POST", path, params)
        response = do_http_with_body(uri, Net::HTTP::Post.new(uri.request_uri, headers), params)
        response.body
      end

      def do_http(uri, request)
        http = set_http_client(uri)
        http.request(request)
      end

      def build_url_with_params(request_method, path, params)
        query_string = make_query_string(request_method, path, params)
        URI.parse "https://#{API_SERVER}#{path}?#{query_string}"
      end

      def make_query_string(request_method, path, params = {})
        h = {
          "AccessKeyId" => access_key,
          "SignatureMethod" => "HmacSHA256",
          "SignatureVersion" => 2,
          "Timestamp"=> Time.now.getutc.strftime("%Y-%m-%dT%H:%M:%S")
        }
        h.merge!(params) if request_method == "GET"
        h["Signature"] = Hadax::Sign.new("GET", path, secret_key, h).signature
        Rack::Utils.build_query(h)
      end

      def set_http_client(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http
      end

      def headers
        {
          'Content-Type'=> 'application/json',
          'Accept' => 'application/json',
          'Accept-Language' => 'zh-CN',
          'User-Agent'=> 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36'
        }
      end
  end
end
