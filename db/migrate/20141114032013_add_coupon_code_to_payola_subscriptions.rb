class AddCouponCodeToPayolaSubscriptions < ActiveRecord::Migration[6.1]
  def change
    add_column :payola_subscriptions, :coupon, :string
  end
end
