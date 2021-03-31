class AddCurrencyToPayolaSubscriptions < ActiveRecord::Migration[6.1]
  def change
    add_column :payola_subscriptions, :currency, :string
    add_column :payola_subscriptions, :amount, :integer
  end
end
