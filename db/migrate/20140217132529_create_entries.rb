class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :sentence

      t.timestamps
    end
  end
end
