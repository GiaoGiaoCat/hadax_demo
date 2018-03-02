#!/usr/bin/env ruby
require_relative 'hadax'

def get_balance(account_id, coin)
  result = @service.get_balance(account_id)
  response = Hadax::Response.new(result)
  list = response.data["list"]
  balance = list.select { |h| h["type"] == "trade" && h["currency"] == coin }.shift
  balance["balance"]
end

def trade(account_id, currency, coin, bid_price, ask_price, amount)
  symbol_pair = "#{coin}#{currency}"
  @service.open_a_position(account_id, symbol_pair, bid_price, amount)

  loop do
    ask_amount = get_balance(account_id, coin)
    @service.close_a_position(account_id, symbol_pair, ask_price, ask_amount)
    sleep 3
  end
end

def working(access_key, secret_key, account_id, currency, coin, bid_price, ask_price, amount, opening_time)
  @service = Hadax.initialize_service(access_key, secret_key)
  # For dev.
  # trade(account_id, currency, coin, bid_price, ask_price, amount)

  # For production.
  loop do
    break trade(account_id, currency, coin, bid_price, ask_price, amount) if Time.now.to_i >= opening_time.to_i
    sleep 2
  end
end

access_key = ARGV.shift
secret_key = ARGV.shift
account_id = ARGV.shift
currency = ARGV.shift
coin = ARGV.shift
bid_price = ARGV.shift
ask_price = ARGV.shift
amount = ARGV.shift
opening_time = ARGV.shift

working(access_key, secret_key, account_id, currency, coin, bid_price, ask_price, amount, opening_time)
