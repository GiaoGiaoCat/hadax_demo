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
