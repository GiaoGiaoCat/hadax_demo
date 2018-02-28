require 'forwardable'
require_relative 'hadax/service'

module Hadax
  class << self
    extend Forwardable

    attr_reader :service

    %i(open_a_position close_a_position can_open_a_position? can_close_a_position?).each do |method_name|
      def_delegators :service, method_name
    end

    def initialize_service(access_key, secret_key)
      @service = Hadax::Service.new(access_key, secret_key)
    end
  end
end
