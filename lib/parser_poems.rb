class ParserPoems

  attr_accessor :poems

  def initialize
    @poems = {}
  end

  def create_poems
    a = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
    page = a.get('http://pushkin.niv.ru/pushkin/text/stihi/sort-name.htm')
    page.links.each do |poem|
      name = poem.text.split(' (').first
      text = poem.click.css('.tmpl_table table td pre').text
      text = text.split("\r\n").reject(&:empty?)
      p name
      update_hash(name, text)
    end
    create_file
  end

  def update_hash(name, text)
    if poems[name]
      poems[name].concat(text)
    else
      poems[name] = text
    end
  end

  def create_file
    File.open('db/poems.json', 'w') do |f|
      f.write(poems.to_json)
    end
  end


end
