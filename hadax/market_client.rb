require 'net/https'
require 'uri'
require 'json'
require 'openssl'
require 'rack'

require_relative 'configuration'

module Hadax
  class MarketClient
    include Configuration

    def get(path, params = {})
      do_get(path, params)
    end

    private
      def do_get(path, params = {})
        uri = build_url_with_params("GET", path, params)
        response = do_http(uri, Net::HTTP::Get.new(uri.request_uri))
        response.body
      end

      def do_http(uri, request)
        http = set_http_client(uri)
        http.request(request)
      end

      def build_url_with_params(request_method, path, params)
        URI.parse "https://#{API_SERVER}#{path}"
      end

      def set_http_client(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http
      end

      def headers
        {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Accept-Language': 'zh-CN',
          'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36'
        }
      end
  end
end
