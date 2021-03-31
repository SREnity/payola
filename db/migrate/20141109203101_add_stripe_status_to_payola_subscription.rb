class AddStripeStatusToPayolaSubscription < ActiveRecord::Migration[6.1]
  def change
    add_column :payola_subscriptions, :stripe_status, :string
  end
end
