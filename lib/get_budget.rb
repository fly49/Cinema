require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

class GetBudget
  def get_budget(movie)
    page = Nokogiri::HTML(get_page(movie))
    fetch_budget(page)
  end

  def get_all_budgets(movies)
    if File.exist?('budgets.yml')
      puts 'Budgets has already been gotten'
      return
    end
    @budgets = movies.each_with_object({}) do |movie, hash|
      hash[movie.imdb_id] = get_budget(movie)
    end
    self
  end

  def save(path)
    File.write(path,@budgets.to_yaml)
  end

  private

  def get_page(movie)
    cache_filename = "movie_pages/#{movie.imdb_id}.html"
    return File.read(cache_filename) if File.exist?(cache_filename)
    open(movie.link, allow_redirections: :safe).read
                                               .tap { |response| File.write(cache_filename, response) }
  end

  def fetch_budget(page)
    text = page.css("div[class='txt-block']").map(&:text).grep(/Budget:/).first
    return unless text
    text.scan(/Budget:\s*(.+)$/).flatten.first
  end
end