class TasksService
  attr_accessor :question, :level

  def initialize(question, level)
    @question = question
    @level = level
  end

  def get_answer
    case level
      when '1'
        POEMS_1[question]
      when '2', '3', '4'
        level_234(POEMS_234)
      when '5'
        level_5(question.include?(',') ? POEMS_5_COMMA : POEMS_5)
      when '6', '7'
        level_67(POEMS_67)
      when '8'
        level_8(POEMS_8)
    end
  end

  def level_234(poems)
    check_str = question.gsub(/[\n[:punct:]]/, '.')
    regexp = Regexp.new(check_str.gsub('.WORD.', '[[:word:]]+'))
    result = regexp.match(poems).to_s.scan(/[[:alpha:]]+/)
    answer = []
    check_str.scan(/[[:alpha:]]+/).each_with_index do |word, index|
      answer << result[index] if word == 'WORD'
    end
    answer.join(',')
  end

  def level_5(poems)
    answer = nil
    words = question.scan(/[[:alpha:]]+/)
    poems[words.size].each do |str|
      errors = 0
      str.each_with_index do |word, index|
        unless word == words[index]
          answer = words[index] + ',' + word
          errors += 1
        end
        break if errors == 2
      end
      return answer if errors == 1
    end
  end

  def level_67(poems)
    poems[question.scan(/[[:alpha:]]/).sort]
  end

  def level_8(poems)
    letters = question.scan(/[[:alpha:]]/).sort
    amount_words = question.scan(/[[:alpha:]]+/).size
    amount_letters = letters.size
    poems[amount_words][amount_letters].each do |key, value|
      first_error = 0
      last_error = key.size
      key.each_with_index do |char, index|
        unless char == letters[index]
          first_error = index
          break
        end
      end
      key.reverse_each do |char|
        last_error -= 1
        break unless char == letters[last_error]
      end
      range1 = (first_error + 1)..last_error
      range2 = first_error...last_error
      return value if key.values_at(range1) == letters.values_at(range2) ||
                      key.values_at(range2) == letters.values_at(range1)
    end
    nil
  end

  # def level_8(poems)
  #   letters = question.scan(/[[:alpha:]]/)
  #   amount_words = question.scan(/[[:alpha:]]+/).size
  #   amount_letters = letters.size
  #   poems[amount_words][amount_letters].each do |key, value|
  #     return value if (key - letters).size < 2 && (letters - key).size < 2
  #   end
  #   nil
  # end
end
