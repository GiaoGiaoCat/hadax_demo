#!/usr/bin/env ruby
require_relative 'hadax'

def get_latest_bid_price(symbol_pair)
  result = @service.get_market_depth(symbol_pair)
  res = Hadax::Response.new(result)
  bid = res.tick["bids"].first
  latest_bid_price = bid[0]
end

def get_precision(currency, coin)
  result = @service.get_symbols
  res = Hadax::Response.new(result)
  precision = res.data.select { |hash| hash["base-currency"] == coin && hash["quote-currency"] == currency }[0]
  precision
end

def trade(account_id, currency, coin, bid_price, amount)
  symbol_pair = "#{coin}#{currency}"
  @service.open_a_position(account_id, symbol_pair, bid_price, amount)
end


def working(access_key, secret_key, account_id, currency, coin, money_amount)
  symbol_pair = "#{coin}#{currency}"
  @service = Hadax.initialize_service(access_key, secret_key)

  # 获取目标交易对精度，price-precision 为价格精度 amount-precision 为交易精度
  precision = get_precision(currency, coin)
  puts price_precision = precision['price-precision']
  puts amount_precision = precision['amount-precision']

  # 获取目标交易买一价格
  puts latest_bid_price = get_latest_bid_price(symbol_pair)

  bid_price = latest_bid_price + 10.0 ** (-price_precision)
  puts bid_price

  amount = (money_amount.to_f / bid_price).round(amount_precision)
  puts amount
  trade(account_id, currency, coin, bid_price, amount)
end

access_key = ARGV.shift
secret_key = ARGV.shift
account_id = ARGV.shift
currency = ARGV.shift
coin = ARGV.shift
money_amount = ARGV.shift

working(access_key, secret_key, account_id, currency, coin, money_amount)
