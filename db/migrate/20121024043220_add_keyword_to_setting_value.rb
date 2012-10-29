class AddKeywordToSettingValue < ActiveRecord::Migration
  def change
    add_column :setting_values, :keyword, :string
    add_index :setting_values, :keyword
  end
end
