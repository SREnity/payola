class AddCustomFieldsToPayolaSale < ActiveRecord::Migration[6.1]
  def change
    add_column :payola_sales, :custom_fields, :text
  end
end
