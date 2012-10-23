class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :user_id, :null => true
      t.integer :organization_id, :null => true
      t.integer :setting_type_id
      t.integer :setting_value_id

      t.timestamps
    end
  end
end
