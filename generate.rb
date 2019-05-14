require "base64"
require "erb"
require 'fileutils'
require "net/http"
require "nokogiri"
require "oj"

DATA_FILE = "data.json"

# For the purpose of quickly iterating on designs, data is only generated once and
# cached in-between runs. Delete the data file to regenerate it.
if File.exist?(DATA_FILE)
  data = Oj.load(File.read(DATA_FILE), symbol_keys: true)
else
  doc = Nokogiri::HTML(Net::HTTP.get(URI("https://smashup.fandom.com/wiki/Category:Factions")))

  names = doc.css(".wikitable tr td:nth-child(1)").
              map { |e| e.text.strip }
  sets = doc.css(".wikitable tr td:first-child").
             map { |e| e.parent.parent.previous.previous.css("b a").text }
  icon_data_urls = doc.css(".wikitable tr td:nth-child(2) img[data-src]").
                       map { |img| img.parent[:href] }. # use an enclosing link to a larger image
                       map { |url| Net::HTTP.get(URI(url)) }.
                       map { |binary| "data:image/png;base64,#{Base64.strict_encode64(binary)}" }
  descriptions = doc.css(".wikitable tr td:nth-child(3)").
                     map { |e| e.text.strip }

  data = names.zip(sets, descriptions, icon_data_urls).map do |n, s, d, i|
    { name: n, set: s, description: d, icon_data_url: i }
  end
  File.write(DATA_FILE, Oj.dump(data))
end

Dir["*.erb"].each do |template_filename|
  File.write(template_filename[0...-4], # minus the `.erb`
             ERB.new(File.read(template_filename))
                         .result(binding))
end
