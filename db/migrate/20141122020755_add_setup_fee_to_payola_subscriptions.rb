class AddSetupFeeToPayolaSubscriptions < ActiveRecord::Migration[6.1]
  def change
    add_column :payola_subscriptions, :setup_fee, :integer
  end
end
