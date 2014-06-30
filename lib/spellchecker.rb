# A basic ruby class which can be called to suggest the proper spelling of a given input
# Runs in constant time with respect to the size of the dictionary
# Runs in polynomial time with respect to the number of letters in the word

class SpellChecker
  class << self
    VOCABULARY_PATH = "/usr/share/dict/words"

    def vocabulary_path
      VOCABULARY_PATH
    end

    def dictionary
      @@dictionary ||= fill_dictionary(Hash.new)
    end

    def vocabulary
      File.new(vocabulary_path)
    end

    # Initialize a key value store of every word in the given vocabulary
    def fill_dictionary(dictionary)
      vocabulary.each { |word| dictionary[word.chomp] = true}
      dictionary
    end

    def get_next_word
      print "> "
      word = gets.chomp
    end

    # Start a loop that suggests words based on user input
    def run(filename=nil)
      if filename
        file = File.new(filename)
        while word = file.gets
          evaluate(word.chomp)
        end
        file.close
      end

      while true
        evaluate(get_next_word)
      end
    end

    def evaluate(word)
      puts is_a_word?(word) ?  word : suggest_word(word)
    end

    def is_a_word?(word)
      dictionary.has_key? word
    end

    # Evaluate a word, and attempt to provide a suggestion of a similar
    # known word, if one exists
    def suggest_word(word)
      test_word = word
      check_case!(test_word)   ||
      strip_doubles(test_word) ||
      check_vowels(test_word)  ||
      "NO SUGGESTION"
    end

    # Destructive method, modifies the word passed to it
    def check_case!(word)
      return word if is_a_word? word
      return word if is_a_word?(word.capitalize!) || is_a_word?(word.downcase!)
      false
    end

    def vowels
      "aeiou"
    end

    # Base case: check if any case of the word you are looking at is a word
    # Else
    #   For each character i in the substring of the word you are looking at:
    #     If i is a vowel, check if substituting i for [aeiou] creates a real word
    def check_vowels(word, starting_index=0)
      test_word = word
      return check_case!(test_word) if check_case!(test_word)

      for i in starting_index...word.length do
        test_word = word
        character = test_word[i]
        if vowels.include? character
          vowels.chars.each do |vowel|
            test_word[i] = vowel
            return check_vowels(test_word, i+1) if check_vowels(test_word, i+1)
          end
        end
      end
      false
    end

    # Base case: the input word is a known word
    # For each letter in the word
    #    if the next letter is the same
    #      remove the doubled letter
    #      recursively call strip_doubles on the new word
    #    call check_vowels on the new word
    #
    #
    def strip_doubles(word, starting_index=0)
      test_word = word
      return test_word if is_a_word?(test_word)

      for idx in starting_index...word.length do
        next_idx = idx + 1
        if test_word[next_idx] && test_word[idx] == test_word[next_idx]
          test_word = test_word[0...idx] + test_word[next_idx..-1]
          return strip_doubles(test_word, idx) if strip_doubles(test_word, idx)
          return check_vowels(test_word) if check_vowels(test_word)
        end
      end

      false
    end
  end
end