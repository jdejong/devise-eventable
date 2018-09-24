# frozen_string_literal: true

require "devise"
require "devise/eventable/version"
require "devise/eventable/models/eventable"

module Devise

  # Stores the events hash
  mattr_accessor :events
  @@events = {}

  def self.on(event, &block)
    @@events[event] = [] unless @@events.key?(event)
    @@events[event] << block
  end

  def self.fire_event(event, val = nil)
    return unless Devise.events[event]
    Devise.events[event].each do |block|
      begin
        block.call(val)
      rescue => e
        Rails.logger.error "[Devise] Eventable.fire_event - #{e.message}" if Rails.logger
        Rails.logger.error "[Devise] Eventable.fire_event - #{e.backtrace.inspect}" if Rails.logger
      end
    end
  end

  module Eventable
  end
end


Devise.add_module :eventable, model: "devise_pwned_password/model"