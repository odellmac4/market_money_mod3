class AddColumnToMarkets < ActiveRecord::Migration[7.1]
  def change
    add_column :markets, :vendor_count, :integer
  end
end
