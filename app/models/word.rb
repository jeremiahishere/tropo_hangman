class Word < ActiveRecord::Base
  has_many :games

  self.random_word
    Word.first
  end
end
