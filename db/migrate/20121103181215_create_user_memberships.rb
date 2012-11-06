class CreateUserMemberships < ActiveRecord::Migration
  def change
    create_table :user_memberships do |t|
      t.integer :user_id
      t.integer :organization_id
      t.integer :organization_role_id
      t.date :start_date
      t.date :end_date, :null => true
    end
  end
end
