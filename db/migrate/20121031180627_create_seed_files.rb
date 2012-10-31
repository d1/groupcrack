class CreateSeedFiles < ActiveRecord::Migration
  def change
    create_table :seed_files do |t|
      t.string :keyword

      t.timestamps
    end
    add_index :seed_files, :keyword, :unique => true
  end
end
