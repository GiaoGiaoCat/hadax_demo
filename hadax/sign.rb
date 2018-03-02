require 'digest/md5'
require 'base64'
require 'rack'

module Hadax
  class Sign
    # API_DOMAIN = "api.huobi.pro"
    API_DOMAIN = "api.hadax.com"

    attr :request_method, :path, :secret_key, :params

    def initialize(request_method, path, secret_key, params)
      @request_method = request_method
      @path = path
      @secret_key = secret_key
      @params = params
    end

    def signature
      signature = OpenSSL::HMAC.digest('sha256', secret_key, format_params)
      Base64.encode64(signature).gsub("\n", "")
    end

    private

      def format_params
        format_params = Rack::Utils.build_query(sort_params)
        "#{request_method}\n#{API_DOMAIN}\n#{path}\n#{format_params}"
      end

      def sort_params
        Hash[params.sort_by { |key, val| key }]
      end
  end
end
