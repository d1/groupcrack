class AddIndexesToSettingAttributes < ActiveRecord::Migration
  def change
    # need to add some more indexes to catch up with past migrations
    add_index :organizations, :subdomain, :unique => true
    add_index :setting_types, :keyword, :unique => true
    add_index :setting_types, :user_modifiable
    add_index :setting_types, :site_or_org_specific
    add_index :setting_values, :setting_type_id
    add_index :setting_values, :default_value
    add_index :settings, :setting_type_id
    add_index :settings, :setting_value_id
    add_index :settings, :user_id
    add_index :settings, :organization_id
  end
end
