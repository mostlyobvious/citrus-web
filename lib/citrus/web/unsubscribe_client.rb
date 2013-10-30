module Citrus
  module Web
    class UnsubscribeClient

      takes :subscription_repository

      def call(client_id)
        subscriptions = subscription_repository.find_all_by_client_id(client_id)
        subscriptions.each { |subscription| subscription_repository.remove_subscription(subscription) }
      end

    end
  end
end
