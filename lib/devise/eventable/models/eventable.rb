# frozen_string_literal: true

require 'devise/eventable/hooks/eventable'

module Devise
  module Models

    # Eventable takes care of sending events when common actions are performed in devise.
    #
    # ==Options
    #
    #
    # == Examples
    #
    #
    module Eventable
      extend ActiveSupport::Concern

      included do
        #if defined?(ActiveRecord) && self < ActiveRecord::Base # ActiveRecord
        #  after_commit :fire_events_on_model_update
        #else # Mongoid
        after_save :fire_events_on_model_update
        #end
      end

      if Devise.activerecord51?
        def fire_events_on_model_update
          Devise.fire_event(:password_change, { record: self } ) if saved_changes_to_encrypted_password?
          Devise.fire_event(:password_reset_sent, { record: self } ) if saved_changes_to_reset_password_token? && !saved_changes_to_encrypted_password?
          Devise.fire_event(:password_reset, { record: self } ) if saved_changes_to_encrypted_password? && saved_changes_to_reset_password_token? && reset_password_token.nil?
          Devise.fire_event(:account_locked, { record: self } ) if saved_changes_to_locked_at? && !locked_at.nil?
          Devise.fire_event(:account_unlocked, { record: self } ) if saved_changes_to_locked_at? && locked_at.nil?
        end
      else
        def fire_events_on_model_update
          Devise.fire_event(:password_change, { record: self } ) if encrypted_password_changed?
          Devise.fire_event(:password_reset_sent, { record: self } ) if reset_password_token_changed? && !encrypted_password_changed?
          Devise.fire_event(:password_reset, { record: self } ) if encrypted_password_changed? && reset_password_token_changed? && reset_password_token.nil?
          Devise.fire_event(:account_locked, { record: self } ) if locked_at_changed? && !locked_at.nil?
          Devise.fire_event(:account_unlocked, { record: self } ) if locked_at_changed? && locked_at.nil?
        end
      end

    end
  end
end