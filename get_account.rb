#!/usr/bin/env ruby
require_relative 'hadax'

def get_account(access_key, secret_key)
  @service = Hadax.initialize_service(access_key, secret_key)
  puts @service.get_account_id
end

access_key = ARGV.shift
secret_key = ARGV.shift

get_account(access_key, secret_key)
