module Citrus
  module Web
    class SubscriptionsRepository

      def initialize
        @subscriptions = Hash.new { |hash, key| hash[key] = [] }
      end

      def create_subscription(subscription)
        subscriptions[subscription.subject] << subscription
      end

      def find_all_by_subject(subject)
        subscriptions[subject]
      end

      def find_all_by_client_id(client_id)
        subscriptions.values.flatten.select { |subscription| subscription.client_id == client_id }
      end

      def remove_subscription(subscription)
        subscriptions[subscription.subject].delete(subscription)
      end

      def subscriptions_count
        subscriptions.values.flatten.size
      end

      protected

      attr_reader :subscriptions

    end
  end
end
