class AddActiveToPayolaCoupon < ActiveRecord::Migration[6.1]
  def change
    add_column :payola_coupons, :active, :boolean, default: true
  end
end
