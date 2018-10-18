require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

module Cinema
  class MovieBudgetGetter
    class << self
      def get_budget(movie)
        page = Nokogiri::HTML(get_page(movie))
        fetch_budget(page)
      end
    
      def get_all_budgets(movies)
        return if File.exist?('data/budgets.yml')
        @budgets = movies.each_with_object({}) do |movie, hash|
          hash[movie.imdb_id] = get_budget(movie)
        end
        self
      end
    
      def save(path)
        File.write(path,@budgets.to_yaml)
        FileUtils.rm_r Dir.glob('data/movie_pages')
      end
    
      private
    
      def get_page(movie)
        cache_file_path = "data/movie_pages/#{movie.imdb_id}.html"
        return File.read(cache_file_path) if File.exist?(cache_file_path)
        dirname = File.dirname(cache_file_path)
        FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
        open(movie.link, allow_redirections: :safe).read
                                                   .tap { |response| File.write(cache_file_path, response) }
      end
    
      def fetch_budget(page)
        text = page.css("div[class='txt-block']").map(&:text).grep(/Budget:/).first
        return unless text
        text.scan(/Budget:\s*(.+)$/).flatten.first
      end
    end
  end
end