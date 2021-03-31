class AddTaxPercentToPayolaSubscriptions < ActiveRecord::Migration[6.1]
  def change
    add_column :payola_subscriptions, :tax_percent, :integer
  end
end
