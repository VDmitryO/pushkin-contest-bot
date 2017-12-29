# require_relative '../../lib/parser_poems'
# ParserPoems.new.create_poems

def get_poems
  poems = JSON.parse(File.read('db/poems.json'))
  poems.each do |name, text|
    text.each_with_index do |str, index|
      str.gsub!(160.chr(Encoding::UTF_8), ' ')
      str.strip!
      str.chop! if /[[:punct:]]/ =~ str[-1]
      #poems[name][index] = str
    end
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
    if str.include? ','
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
    amount_words = str.scan(/[[:alpha:]]+/).size
    amount_letters = letters.size
    poems8[amount_words] ||= {}
    poems8[amount_words][amount_letters] ||= {}
    poems8[amount_words][amount_letters][letters] = str
  end
  poems8
end


poems = get_poems
POEMS_1 = get_poems1(poems)
POEMS_234 = poems.values.join(' ')
poems5 = get_poems5(poems)
POEMS_5_COMMA = poems5[0]
POEMS_5 = poems5[1]
POEMS_67 = get_poems67(poems)
POEMS_8 = get_poems8(poems)

URL = URI('http://pushkin.rubyroidlabs.com/quiz')
API_KEY = '1ce3d04a59f4c7249c012f179560302e'