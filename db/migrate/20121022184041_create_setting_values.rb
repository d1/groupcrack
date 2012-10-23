class CreateSettingValues < ActiveRecord::Migration
  def change
    create_table :setting_values do |t|
      t.integer :setting_type_id
      t.string :name
      t.integer :position, :default => 0
      t.integer :default_value, :default => 0
      t.integer :locked, :default => 0

      t.timestamps
    end
  end
end
