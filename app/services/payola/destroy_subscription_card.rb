module Payola
  class DestroySubscriptionCard
    def self.call(subscription)
      secret_key = Payola.secret_key
      customer = Stripe::Customer.retrieve(subscription.stripe_customer_id, secret_key)
      # TODO: Hack for when we only allow a single card.  Just destroy the
      #    first (only) one.
      customer.sources.data[0].delete()
    end
  end
end
