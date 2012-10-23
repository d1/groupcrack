class CreateSettingTypes < ActiveRecord::Migration
  def change
    create_table :setting_types do |t|
      t.string :name
      t.text :description
      t.string :keyword
      t.string :site_or_org_specific
      t.integer :user_specific, :default => 0
      t.integer :user_modifiable, :default => 0
      t.integer :locked, :default => 0
      t.timestamps
    end
  end
end
