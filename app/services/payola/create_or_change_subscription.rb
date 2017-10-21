module Payola
  class CreateOrChangeSubscription
    def self.call(subscription, plan, quantity = 1, coupon_code = nil)
      # This method is used when you're updating a subscription with an existing
      #   customer.  If the subscription has been cancelled or totally ended,
      #   then Stripe will return no valid subscriptions, and one needs to be
      #   created.

      secret_key = Payola.secret_key_for_sale(subscription)

      begin
        sub = retrieve_subscription_for_customer(subscription, secret_key)
      rescue Stripe::InvalidRequestError
        affiliate = (subscription.affiliate_id.nil? ? nil : Payola::Affiliate.find(subscription.affiliate_id))

        customer = Stripe::Customer.retrieve(subscription.stripe_customer_id, Payola.secret_key)
        email = customer.email

        sub = Payola::Subscription.new do |s|
          s.plan = plan
          s.email = email
          s.stripe_token = subscription.stripe_token if plan.amount > 0
          s.affiliate_id = affiliate.try(:id)
          s.currency = plan.respond_to?(:currency) ? plan.currency : Payola.default_currency
          s.coupon = nil #params[:coupon]
          s.signed_custom_fields = subscription.signed_custom_fields
          s.setup_fee = nil #subscription.setup_fee
          s.quantity = subscription.quantity
          s.trial_end = DateTime.now.to_i
          s.tax_percent = subscription.tax_percent
          s.stripe_customer_id = customer.id if customer

          s.owner = subscription.owner
          s.amount = plan.amount
        end

        if sub.save!
           Payola.queue!(Payola::ProcessSubscription, sub.guid)
           subscription.delete.save!
        end

        sub
      else
        Payola::ChangeSubscriptionPlan.call(subscription, plan)
      end
    end

    def self.retrieve_subscription_for_customer(subscription, secret_key)
      customer = Stripe::Customer.retrieve(subscription.stripe_customer_id, secret_key)
      customer.subscriptions.retrieve(subscription.stripe_id)
    end

  end
end
