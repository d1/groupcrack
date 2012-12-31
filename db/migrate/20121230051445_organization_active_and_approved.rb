class OrganizationActiveAndApproved < ActiveRecord::Migration
  def change
    add_column :organizations, :active, :integer, :default => 1
    add_index :organizations, :active
    add_column :organizations, :approved, :integer, :default => 1
    add_index :organizations, :approved
  end
end
