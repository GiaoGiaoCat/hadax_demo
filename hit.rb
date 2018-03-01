#!/usr/bin/env ruby
require_relative 'hadax'

def trade(symbol_pair, bid_price, ask_price)
  @service.open_a_position(symbol_pair, bid_price) if @service.can_open_a_position?
  @service.close_a_position(symbol_pair, ask_price) if @service.can_close_a_position?
end

def working(access_key, secret_key, symbol_pair, bid_price, ask_price, opening_time)
  puts access_key
  @service = Hadax.initialize_service(access_key, secret_key)

  # trade(symbol_pair, bid_price, ask_price) # For dev.
  puts @service.get_account_id

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
