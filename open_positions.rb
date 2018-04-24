#!/usr/bin/env ruby
require_relative 'hadax'

def get_balance(account_id, coin)
  result = @service.get_balance(account_id)
  response = Hadax::Response.new(result)
  list = response.data["list"]
  balance = list.select { |h| h["type"] == "trade" && h["currency"] == coin }.shift
  balance["balance"]
end

def trade(account_id, currency, coin, bid_price, amount)
  symbol_pair = "#{coin}#{currency}"
  @service.open_a_position(account_id, symbol_pair, bid_price, amount)
end

def working(access_key, secret_key, account_id, currency, coin, bid_price, step_price, step, amount)
  @service = Hadax.initialize_service(access_key, secret_key)
  # For production.
  step.to_i.times do
    trade(account_id, currency, coin, bid_price, amount)
    bid_price = bid_price.to_f + step_price.to_f
  end
  puts "搞定"
end

access_key = ARGV.shift
secret_key = ARGV.shift
account_id = ARGV.shift
currency = ARGV.shift
coin = ARGV.shift
bid_price = ARGV.shift
step_price = ARGV.shift
step = ARGV.shift
amount = ARGV.shift

working(access_key, secret_key, account_id, currency, coin, bid_price, step_price, step, amount)
