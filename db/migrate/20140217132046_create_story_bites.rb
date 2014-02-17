class CreateStoryBites < ActiveRecord::Migration
  def change
    create_table :story_bites do |t|
      t.string :sentence

      t.timestamps
    end
  end
end
