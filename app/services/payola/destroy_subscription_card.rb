module Payola
  class DestroySubscriptionCard
    def self.call(subscription)
      secret_key = Payola.secret_key
      customer = Stripe::Customer.retrieve(subscription.stripe_customer_id, secret_key)
      # TODO: Hack for when we only allow a single card.  Just destroy the
      #    first (only) one.
      begin
        customer.sources.data[0].delete()
        subscription.update_attributes(
          card_type: nil,
          card_last4: nil,
          card_expiration: nil
        )
        subscription.save!
      rescue RuntimeError, Stripe::StripeError => e
        byebug
        subscription.errors[:base] << e.message
      end
    end
  end
end
