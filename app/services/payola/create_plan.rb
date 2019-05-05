module Payola
  class CreatePlan
    def self.call(plan)
      secret_key = Payola.secret_key_for_sale(plan)

      begin
        return Stripe::Plan.retrieve(plan.stripe_id, secret_key)
      rescue Stripe::InvalidRequestError
        # fall through
      end

      Stripe::Plan.create({
        id:                plan.stripe_id,
        amount:            plan.amount,
        interval:          plan.interval,
        name:              plan.name,
        aggregate_usage:   plan.respond_to?(:aggregate_usage) ? plan.aggregate_usage : nil, 
        usage_type:        plan.respond_to?(:usage_type) ? plan.usage_type : nil,
        interval_count:    plan.respond_to?(:interval_count) ? plan.interval_count : nil,
        currency:          plan.respond_to?(:currency) ? plan.currency : Payola.default_currency,
        trial_period_days: plan.respond_to?(:trial_period_days) ? plan.trial_period_days : nil
      }, secret_key)
    end
  end
end
