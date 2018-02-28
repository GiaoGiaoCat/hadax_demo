#!/usr/bin/env ruby
require 'forwardable'
require 'net/http'
require 'uri'
require 'json'
require 'digest/md5'
require 'base64'

require_relative 'hadax/client'

module Hadax
  class << self
    extend Forwardable

    API_URL = "http://sdk.open.api.igexin.com/apiex.htm"

    attr_reader :client

    def_delegators :client, :push_message_to_single
    def_delegators :client, :push_message_to_list

    def client(access_key, secret_key)
      @client = Hadax::Client.new(access_key, secret_key)
    end
  end
end


# 2. 开仓：每秒并发5个线程 同时以买入价全仓买入，买入成功后，标记状态，并停止买入动作。
# 3. 平仓：每秒并发5个线程 同时以卖出价全仓买出，卖出成功后，标记状态，并回显示。
def trade(symbol_pair, bid_price, ask_price)
  @client.open_a_position(symbol_pair, bid_price) if @client.can_open_a_position?
  @client.close_a_position(symbol_pair, ask_price) if @client.can_close_a_position?
end

# 1. 每隔 X 秒循环一次，以判断当前时间点是否进入交易状态
def working(access_key, secret_key, symbol_pair, bid_price, ask_price, opening_time)
  @client = Hadax.client(access_key, secret_key)

  trade(symbol_pair, bid_price, ask_price) # For dev.

  # For production.
  # loop do
  #   break trade if Time.now.to_i > opening_time.to_i
  #   sleep 3
  # end
end


access_key = ARGV.shift
secret_key = ARGV.shift
symbol_pair = ARGV.shift
bid_price = ARGV.shift
ask_price = ARGV.shift
opening_time = ARGV.shift

working(access_key, secret_key, symbol_pair, bid_price, ask_price, opening_time)
