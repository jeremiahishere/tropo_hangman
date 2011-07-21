class Word < ActiveRecord::Base
  has_many :games

  def self.random_word
    Word.first
  end
end
