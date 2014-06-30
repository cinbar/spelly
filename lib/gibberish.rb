class Gibberish
  class << self
    VOCABULARY_PATH = "bad_words.txt"
    def vocabulary_path
      VOCABULARY_PATH
    end

    def generate!(vocabulary)
      bad_words = File.new(vocabulary_path, "w+")
      100.times do
        bad_words.puts to_gibberish(vocabulary.sample)
      end
      bad_words.close
    end

    def to_gibberish(word)
      new_word = "#{word}"
      3.times do
        case Random.new.rand(0..2)
        when 0
          random_capitalize! new_word
        when 1
          new_word = random_double(new_word)
        else
          random_vowel! new_word
        end
      end
      new_word
    end

    def random_capitalize!(word)
      i = Random.new.rand(0...word.length)
      word[i] = word[i].upcase
      word
    end

    def random_double(word)
      i = Random.new.rand(0...word.length)
      word = word[0..i] + word[i..-1]
    end

    def random_vowel!(word)
      i = Random.new.rand(0...word.length)
      if "aeiou".include? word[i]
        word[i] = "aeiou"[Random.new.rand(0...5)]
      end
      word
    end
  end
end