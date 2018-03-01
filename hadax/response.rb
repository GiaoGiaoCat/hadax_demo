require 'json'
module Hadax
  class Response
    attr :res

    def initialize(res)
      @res = JSON.parse(res)
    end

    def status
      res["status"]
    end

    def data
      res["data"]
    end
  end
end
