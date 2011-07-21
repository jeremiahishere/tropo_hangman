class Game < ActiveRecord::Base
  belongs_to :user
  belongs_to :word

  def guess_letter(guess)
    guess.downcase!
    letters = self.guessed_letters.split(//)
    letters.push(guess) unless letters.include?(guess)
    letters.sort
    self.guessed_letters = letters.join('')
    save
  end

  def win?
    word_letters = self.word.name.split(//)
    guesses = self.guessed_letters.split(//)
    word_letters.each do |letter|
      if !guesses.include?(letter)
        return false
      end
    end
    return true
  end

  def partial_word
    output = ""
    word_letters = self.word.name.split(//)
    guesses = self.guessed_letters.split(//)
    word_letters.each do |letter|
      if guesses.include?(letter)
        output += letter
      else
        output += "_ "
      end
    end
    return output
  end
end
