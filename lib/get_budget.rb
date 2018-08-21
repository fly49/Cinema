require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

def get_budget(movie)
  unless File.exist?("movie_pages/#{movie.imdb_id}.html")
    page = Nokogiri::HTML(open(movie.link, :allow_redirections => :safe).read)
    File.open(File.join("movie_pages/", "#{movie.imdb_id}.html"), 'w') do |f|
      f.write(page)
    end
  end
  page = Nokogiri::HTML(File.read("movie_pages/#{imdb_id}.html"))
  html_data = page.css("div[class='txt-block']").select{|el| el.text.include?('Budget')}
  if html_data.empty?
    'Unknown budget'
  else
    html_data.first.text.match('Budget:.*').to_s.gsub("Budget:", "")
  end
end