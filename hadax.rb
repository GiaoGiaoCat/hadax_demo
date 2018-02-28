#!/usr/bin/env ruby
require 'forwardable'
require_relative 'hadax/client'

module Hadax
  class << self
    extend Forwardable

    attr_reader :client

    %i(open_a_position close_a_position can_open_a_position? can_close_a_position?).each do |method_name|
      def_delegators :client, method_name
    end

    def initialize_client(access_key, secret_key)
      @client = Hadax::Client.new(access_key, secret_key)
    end
  end
end

def trade(symbol_pair, bid_price, ask_price)
  @service.open_a_position(symbol_pair, bid_price) if @service.can_open_a_position?
  @service.close_a_position(symbol_pair, ask_price) if @service.can_close_a_position?
end

def working(access_key, secret_key, symbol_pair, bid_price, ask_price, opening_time)
  @service = Hadax.initialize_client(access_key, secret_key)

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
