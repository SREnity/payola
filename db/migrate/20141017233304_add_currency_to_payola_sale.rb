class AddCurrencyToPayolaSale < ActiveRecord::Migration[6.1]
  def change
    add_column :payola_sales, :currency, :string
  end
end
