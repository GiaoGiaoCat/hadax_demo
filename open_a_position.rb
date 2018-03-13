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

def get_order_field_cash_amount(order_id)
  result = @service.get_order(order_id)
  res = Hadax::Response.new(result)
  res.data["field-cash-amount"].to_f
end

def trade(account_id, currency, coin, bid_price, amount)
  symbol_pair = "#{coin}#{currency}"
  result = @service.open_a_position(account_id, symbol_pair, bid_price, amount)
  res = Hadax::Response.new(result)
  res.data
end

def cancel_order(order_id)
  result = @service.cancel_order(order_id)
  res = Hadax::Response.new(result)
  res.data["field-amount"].to_f
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
  bid_price = (latest_bid_price - 10.0 ** (-price_precision) * 3).round(price_precision)

  puts "价格精度 #{price_precision} 交易精度 #{amount_precision} 买一价格 #{latest_bid_price} 出价 #{bid_price}"

  amount = (money_amount.to_f / bid_price).round(amount_precision)
  order_id = trade(account_id, currency, coin, bid_price, amount)

puts "下单完毕，出价 #{bid_price} 数量 #{amount} 订单 #{order_id}"

  loop do
    sleep 10
    field_amount = get_order_field_amount(order_id)
    if field_amount.round(amount_precision) == amount
      break puts "交易完成"
    else
      new_latest_bid_price = get_latest_bid_price(symbol_pair)
      new_bid_price = (latest_bid_price + 10.0 ** (-price_precision)).round(price_precision)
      if new_bid_price == bid_price
        puts "买一价没变，等待下次循环"
      else
        puts "买一价偏离，更新价格，准备重做订单"
        field_cash_amount = get_order_field_cash_amount(order_id).round(price_precision)
        if field_cash_amount.zero?
          puts "订单没有成交部分，正在撤单并重新下单"
        else
          puts "订单已成交 #{field_cash_amount}，正在撤单，需重新计算买入量再下单"
        end
        cancel_order(order_id)
        bid_price = new_bid_price
        amount = ((money_amount.to_f - field_cash_amount) / bid_price).round(amount_precision)
        order_id = trade(account_id, currency, coin, bid_price, amount)
        puts "更新完毕，出价 #{bid_price} 数量 #{amount} 订单 #{order_id}"
      end
    end
  end
end

access_key = ARGV.shift
secret_key = ARGV.shift
account_id = ARGV.shift
currency = ARGV.shift
coin = ARGV.shift
money_amount = ARGV.shift

working(access_key, secret_key, account_id, currency, coin, money_amount)
