#!/usr/bin/env ruby
require_relative 'hadax'

def trade(account_id, symbol_pair, bid_price, ask_price)
  @service.open_a_position(account_id, symbol_pair, bid_price) #if @service.can_open_a_position?
  @service.close_a_position(account_id, symbol_pair, ask_price) #if @service.can_close_a_position?
end

def working(access_key, secret_key, account_id, symbol_pair, bid_price, ask_price, opening_time)
  @service = Hadax.initialize_service(access_key, secret_key)
  trade(account_id, symbol_pair, bid_price, ask_price) # For dev.

  # For production.
  # loop do
  #   break trade if Time.now.to_i > opening_time.to_i
  #   sleep 3
  # end
end

access_key = ARGV.shift
secret_key = ARGV.shift
account_id = ARGV.shift
symbol_pair = ARGV.shift
bid_price = ARGV.shift
ask_price = ARGV.shift
opening_time = ARGV.shift

working(access_key, secret_key, account_id, symbol_pair, bid_price, ask_price, opening_time)
