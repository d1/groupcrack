class CreateOrganizationRoleSettings < ActiveRecord::Migration
  def change
    create_table :organization_role_settings do |t|
      t.integer :organization_role_id
      t.integer :setting_type_id
      t.integer :setting_value_id
    end
  end
end
