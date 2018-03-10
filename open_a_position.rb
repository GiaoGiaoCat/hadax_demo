#!/usr/bin/env ruby
require_relative 'hadax'

def get_latest_bid_price(service, symbol_pair)
  result = service.get_market_depth(symbol_pair)
  res = Hadax::Response.new(result)
  bid = res.tick["bids"].first
  latest_bid_price = bid[0]
end

def get_precision(service, currency, coin)
  result = service.get_symbols
  res = Hadax::Response.new(result)
  precision = res.data.select { |hash| hash["base-currency"] == coin && hash["quote-currency"] == currency }[0]
  precision
end

def working(access_key, secret_key, account_id, currency, coin)
  symbol_pair = "#{coin}#{currency}"
  @service = Hadax.initialize_service(access_key, secret_key)

  # 获取目标交易对精度，price-precision 为价格精度 amount-precision 为交易精度
  precision = get_precision(@service, currency, coin)
  puts price_precision = precision['price-precision']
  puts amount_precision = precision['amount-precision']

  # 获取目标交易买一价格
  puts latest_bid_price = get_latest_bid_price(@service, symbol_pair)
end

access_key = ARGV.shift
secret_key = ARGV.shift
account_id = ARGV.shift
currency = ARGV.shift
coin = ARGV.shift

working(access_key, secret_key, account_id, currency, coin)
