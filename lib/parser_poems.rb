class ParserPoems
  attr_accessor :poems

  def initialize
    @poems = {}
  end

  def create_poems
    a = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
    page = a.get('http://rvb.ru/pushkin/toc.htm')
    css_array = ['.versusia span', '.versusvia span', '.versusia2 span',
                 '.versusd2 span', '.versusam2 span', '.versusia3 span',
                 '.versusia4 span', '.versusch4 span', '.versusam4 span',
                 '.versusia5 span', '.versusia6 span', '.versusd6 span']
    add_poems(page.links[72].click.links.values_at(74..399), css_array)
    add_poems(page.links[73].click.links.values_at(73..558), css_array)
    add_poems(page.links[74].click.links.values_at(73..124), css_array)
    create_file
  end

  def add_poems(list_poems, css_array)
    list_poems.each do |poem|
      name = poem.text.split(/( \(| — 1)/).first
      next if /[[:digit:]]\./ =~ name || %w[I V].include?(poem.text[0])
      p name
      poems[name] ||= []
      css_array.each do |css|
        poem.click.css(css).each do |str|
          poems[name] << str.text
        end
      end
    end
  end

  def create_file
    File.open('db/poems.json', 'w') do |f|
      f.write(poems.to_json)
    end
  end

  # def create_poems
  #   a = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
  #   page = a.get('http://pushkin.niv.ru/pushkin/text/stihi/sort-name.htm')
  #   page.links.each do |poem|
  #     name = poem.text.split(' (').first
  #     text = poem.click.css('.tmpl_table table td pre').text
  #     text = text.split("\r\n").reject(&:empty?)
  #     p name
  #     update_hash(name, text)
  #   end
  #   create_file
  # end

  # def update_hash(name, text)
  #   if poems[name]
  #     poems[name].concat(text)
  #   else
  #     poems[name] = text
  #   end
  # end
end
