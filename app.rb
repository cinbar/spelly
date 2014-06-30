require_relative 'lib/gibberish'
require_relative 'lib/spellchecker'

Gibberish.generate!(SpellChecker.dictionary.keys)
SpellChecker.run(Gibberish.vocabulary_path)



