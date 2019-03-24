require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

module Cinema
  class MovieBudgetGetter
    class << self
      def get_budget(id)
        page = Nokogiri::HTML(get_page(id))
        fetch_budget(page)
      end
    
      def get_all_budgets(ids)
        return if File.exist?('data/extra_data.yml')
        @budgets = ids.each_with_object({}) do |id, hash|
          hash[id] = { 'budget' => get_budget(id) }
        end
        FileUtils.rm_r Dir.glob('data/movie_pages')
        @budgets
      end
    
      private
    
      def get_page(id)
        cache_file_path = "data/movie_pages/#{id}.html"
        return File.read(cache_file_path) if File.exist?(cache_file_path)
        dirname = File.dirname(cache_file_path)
        FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
        movie_link = "http://imdb.com/title/#{id}/"
        open(movie_link, allow_redirections: :safe).read
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
