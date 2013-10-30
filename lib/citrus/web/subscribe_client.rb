module Citrus
  module Web
    class SubscribeClient

      takes :subscription_repository

      def call(client_id, subject)
        subscription_repository.create_subscription(Subscription.new(client_id, subject))
      end

    end
  end
end
