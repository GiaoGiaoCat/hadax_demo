#!/usr/bin/env ruby
require 'bigdecimal'

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

def get_order_field_amount(order_id)
  result = @service.get_order(order_id)
  res = Hadax::Response.new(result)
  res.data["field-amount"].to_f
end

def trade(account_id, currency, coin, bid_price, amount)
  symbol_pair = "#{coin}#{currency}"
  result = @service.open_a_position(account_id, symbol_pair, bid_price, amount)
  res = Hadax::Response.new(result)
  res.data
end

def should

end

def working(access_key, secret_key, account_id, currency, coin, money_amount)
  symbol_pair = "#{coin}#{currency}"
  @service = Hadax.initialize_service(access_key, secret_key)

  # 获取目标交易对精度，price-precision 为价格精度 amount-precision 为交易精度
  precision = get_precision(currency, coin)
  price_precision = precision['price-precision']
  amount_precision = precision['amount-precision']

  # 获取目标交易买一价格
  latest_bid_price = get_latest_bid_price(symbol_pair)
  # NOTE: 这里为了方便测试，设置买入价低于当前买一价格，上线时候请把 `latest_bid_price -` 改成 `latest_bid_price +`
  bid_price = (latest_bid_price - 10.0 ** (-price_precision)).round(price_precision)

  puts "价格精度 #{price_precision} 交易精度 #{amount_precision} 买一价格 #{latest_bid_price} 出价 #{bid_price}"

  amount = (money_amount.to_f / bid_price).round(amount_precision)
  order_id = trade(account_id, currency, coin, bid_price, amount)

  loop do
    field_amount = get_order_field_amount(order_id)
    if field_amount.round(amount_precision) == amount
      break puts "交易完成"
    else
      new_latest_bid_price = get_latest_bid_price(symbol_pair)
      new_bid_price = (latest_bid_price + 10.0 ** (-price_precision)).round(price_precision)
      if new_bid_price == bid_price
        puts "买一价没变，等待下次循环"
      else
        puts "买一价偏离，等待撤单重新下单"
      end
    end
    sleep 10
  end
end

access_key = ARGV.shift
secret_key = ARGV.shift
account_id = ARGV.shift
currency = ARGV.shift
coin = ARGV.shift
money_amount = ARGV.shift

working(access_key, secret_key, account_id, currency, coin, money_amount)
