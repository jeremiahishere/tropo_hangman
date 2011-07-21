class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :user_id
      t.integer :word_id
      t.boolean :in_progress
      t.string :guessed_letters

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
