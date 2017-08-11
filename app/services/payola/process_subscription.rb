module Payola
  class ProcessSubscription
    def self.call(guid)
      sub = Subscription.unscoped.find_by(guid: guid)
      Tenant.set_current_tenant(sub.tenant_id)
      sub.process!
    end
  end
end
