class AddPriorityToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :priority, :integer, :default => 10
    add_index :settings, :priority
  end
end
