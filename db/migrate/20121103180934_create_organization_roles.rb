class CreateOrganizationRoles < ActiveRecord::Migration
  def change
    create_table :organization_roles do |t|
      t.integer :organization_id, :null => true
      t.string :name
      t.integer :sign_up_role, :default => 0
      t.integer :admin_role, :default => 0
    end
  end
end
