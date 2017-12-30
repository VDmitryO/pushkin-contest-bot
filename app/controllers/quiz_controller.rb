class QuizController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @tasks = Task.page(params[:page]).per(100)
  end

  def create
    @question = params[:question].lstrip
    answer = case params[:level]
             when 1
               POEMS_1[@question]
             when 2
               level_2(POEMS_2)
             when 3, 4
               level_34(POEMS_34)
               when 5
               level_5(/[[:punct:]]/ =~ @question ? POEMS_5_P : POEMS_5)
             when 6, 7
               POEMS_67[@question.scan(/[[:alpha:]]/).sort]
             when 8
               level_8(POEMS_8)
             end
    parameters = { answer: answer, token: API_KEY, task_id: params[:id] }
    Net::HTTP.post_form(URL, parameters)
    task_params = { level: params[:level], question: @question, answer: answer }
    # Task.new(task_params).save
    TaskWorker.perform_async(task_params)
    render json: 'ok'
  end

  private

  def level_2(poems)
    check_str = @question.gsub(/[\n[:punct:]]/, '.')
    regexp = Regexp.new(check_str.gsub('.WORD.', '[[:word:]]+'))
    result = regexp.match(poems).to_s.scan(/[[:alpha:]]+/)
    result[check_str.scan(/[[:alpha:]]+/).index('WORD')]
  end

  def level_34(poems)
    check_str = @question.gsub(/[\n[:punct:]]/, '.')
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
    words = @question.scan(/[[:alpha:]]+/)
    poems[words.size].each do |str|
      errors = 0
      str.each_with_index do |word, index|
        unless word == words[index]
          answer = word + ',' + words[index]
          errors += 1
        end
        break if errors == 2
      end
      return answer if errors == 1
    end
    answer
  end

  def level_8(poems)
    letters = @question.scan(/[[:alpha:]]/).sort
    poems[letters.size].each do |key, value|
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
end
