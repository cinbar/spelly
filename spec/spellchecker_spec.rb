require 'rspec'
require_relative '../lib/spellchecker'

describe 'SpellChecker' do
  before(:each) do
    SpellChecker.stub(:vocabulary).and_return(["inside", "job", "wake", "conspiracy", "sheep", "people", "ants", "bugs", "worms"])
  end

  context 'SpellChecker class methods' do

    context 'dictionary' do
      it 'initializes a dictionary of words' do
        SpellChecker.dictionary.keys.should_not be_empty
      end

      it 'any word in the vocabulary should be defined as a word' do
        SpellChecker.is_a_word?(SpellChecker.vocabulary.sample).should be_true
      end

      it 'any word not in the vocabulary is not a word' do
        SpellChecker.is_a_word?("spotieodiedopalicious").should be_false
      end
    end

    context 'suggest_word' do
      it 'checks the case of a word' do
        SpellChecker.suggest_word("Ants").should eq("ants")
        SpellChecker.suggest_word("ANTS").should eq("ants")
      end

      it 'checks the case of a word and any permutation with double letters removed' do
        SpellChecker.suggest_word("Worms").should eq("worms")
      end

      it 'checks the case of a word, any permutation \\
         with double letters removed, and all \\
         permutations of vowels within the subsets of those \\
         words with double letters removed' do
        SpellChecker.suggest_word("BUUggs").should eq("bugs")
      end
    end
  end

  context 'explicitly defined test cases' do

    it "passes the tests" do
      SpellChecker.suggest_word("inSIDE").should   eq("inside")
      SpellChecker.suggest_word("sheeeeep").should eq("sheep")
      SpellChecker.suggest_word("peeple").should   eq("people")
      SpellChecker.suggest_word("sheeple").should  eq("NO SUGGESTION")
      SpellChecker.suggest_word("jjoobbb").should  eq("job")
      SpellChecker.suggest_word("CUNsperrICY").should eq("conspiracy")
    end

  end
end