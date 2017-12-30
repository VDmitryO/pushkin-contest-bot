# require_relative '../../lib/parser_poems'
# ParserPoems.new.create_poems

def get_poems_with_punct
  poems = JSON.parse(File.read('db/poems.json'))
  poems.values.flatten.each do |str|
    str.gsub!(160.chr(Encoding::UTF_8), ' ')
    str.strip!
  end
  poems
end

def update_poems(poems)
  poems.each do |k, v|
    poems.delete(k) if v.size > 10
  end
end

def update_poems1(poems)
  poems.each do |k, v|
    poems.delete(k) if v.size > 320
  end
end

def get_poems_without_punct(poems)
  poems.values.flatten.each do |str|
    str.chop! if /[[:punct:]]/ =~ str[-1]
  end
  poems
end

def get_poems1(poems)
  poems1 = {}
  poems.each do |name, text|
    text.each do |str|
      poems1[str] = name
    end
  end
  poems1
end

def get_poems5(poems)
  poems5 = [{}, {}]
  poems.values.flatten.each do |str|
    words = str.scan(/[[:alpha:]]+/)
    amount = words.size
    if /[[:punct:]]/ =~ str
      poems5[0][amount] ||= []
      poems5[0][amount] << words
    else
      poems5[1][amount] ||= []
      poems5[1][amount] << words
    end
  end
  poems5
end

def get_poems67(poems)
  poems6 = {}
  poems.values.flatten.each do |str|
    letters = str.scan(/[[:alpha:]]/).sort
    poems6[letters] = str
  end
  poems6
end

def get_poems8(poems)
  poems8 = {}
  poems.values.flatten.each do |str|
    letters = str.scan(/[[:alpha:]]/).sort
    amount_letters = letters.size
    poems8[amount_letters] ||= {}
    poems8[amount_letters][letters] = str
  end
  poems8
end

poems_with_punct = get_poems_with_punct
update_poems1(poems_with_punct)
# update_poems(poems_with_punct)
# binding.pry
poems = get_poems_without_punct(poems_with_punct.deep_dup)
POEMS_1 = get_poems1(poems)
POEMS_2 = poems.values.join(' ')
POEMS_34 = poems_with_punct.values.join(' ')
poems5 = get_poems5(poems)
POEMS_5_P = poems5[0] # With punctuation
POEMS_5 = poems5[1] # Without punctuation
POEMS_67 = get_poems67(poems)
POEMS_8 = get_poems8(poems)

URL = URI('http://pushkin.rubyroidlabs.com/quiz')
API_KEY = '1ce3d04a59f4c7249c012f179560302e'