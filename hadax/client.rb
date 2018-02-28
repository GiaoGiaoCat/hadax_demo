module Hadax
  class Client
    attr :access_key, :secret_key, :status

    def initialize(access_key, secret_key)
      @access_key = access_key
      @secret_key = secret_key
      @status = 0
    end

    # 开仓：以买入价全仓买入，买入成功后，标记状态，并停止买入动作。
    def open_a_position(symbol_pair, bid_price)
      puts "open_a_position will call api"
      change_status(1)
    end

    # 平仓：以卖出价全仓买出，卖出成功后，标记状态，并回显示。
    def close_a_position(symbol_pair, ask_price)
      puts "close_a_position will call api"
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
