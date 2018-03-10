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

    def tick
      res["tick"]
    end
  end
end
