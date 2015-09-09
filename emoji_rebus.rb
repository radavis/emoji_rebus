require "nokogiri"
require "open-uri"
require "pry"

class EmojiRebus
  SOURCE_URL = "http://www.emoji-cheat-sheet.com/"
  SOURCE_FILE = "./tmp/emojis.html"

  attr_reader :emojis

  def initialize(quantity)
    @quantity = quantity
    @emojis = all_emojis.sample(@quantity)
  end

  private

  def source
    html = nil
    if File.exists?(SOURCE_FILE)
      html = File.read(SOURCE_FILE)
    else
      html = open(SOURCE_URL).read
      File.open(SOURCE_FILE, "w") { |f| f.write(html) }
    end
    Nokogiri::HTML(html)
  end

  def all_emojis
    source.css('ul.emojis div').map(&:text).map { |i| i.gsub(/\s+/, '') }
  end

  def to_s
    emojis.join(' ')
  end
end

if __FILE__ == $0
  if ARGV[0]
    puts EmojiRebus.new(ARGV[0].to_i)
  else
    puts EmojiRebus.new(3)
  end
end
