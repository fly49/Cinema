require 'virtus'
require_relative 'get_budget'

class ArrOfStr < Virtus::Attribute
  def coerce(value)
    value.split(',')
  end
end

class Minutes < Virtus::Attribute
  def coerce(value)
    value.chomp(' min').to_i
  end
end

module Cinema
  # Movie contains information about specific movie and provides it in convinient form.
  class Movie
    include Virtus.model

    attribute :link, String
    attribute :title, String
    attribute :year, Integer
    attribute :country, String
    attribute :date, String
    attribute :genre, ArrOfStr
    attribute :duration, Minutes
    attribute :rating, Float
    attribute :director, String
    attribute :cast, ArrOfStr

    def self.create(hash, collection)
      case hash[:year].to_i
      when 1900..1945
        AncientMovie.new(hash, collection)
      when 1945..1968
        ClassicMovie.new(hash, collection)
      when 1968..2000
        ModernMovie.new(hash, collection)
      else
        NewMovie.new(hash, collection)
      end
    end

    def initialize(params,collection)
      @collection = collection
      super params
    end

    def to_s
      "#{@title} (#{@date}; #{@genre}) - #{@duration}"
    end

    def imdb_id
      @link.match(/tt\d{5,7}/).to_s
    end

    def month
      Date::MONTHNAMES[@date.split('-')[1].to_i] || 'Unknown'
    end

    def period
      self.class.name.split('::').last.chomp('Movie').downcase.to_sym
    end

    def rus_title
      @collection.img_base.dig(imdb_id,1)
    end

    def img_url
      @collection.img_base.dig(imdb_id,2)
    end
    
    def budget
      @collection.budget_base[imdb_id]
    end

    # rubocop:disable Naming/PredicateName
    def has_genre?(str)
      raise('Incorrect genre!') unless @collection.genres.include?(str)
      @genre.include?(str)
    end
    # rubocop:enable Naming/PredicateName
  end

  class AncientMovie < Movie
    def to_s
      "«#{@title}» - Old Movie (#{@year})."
    end
  end

  class ClassicMovie < Movie
    def to_s
      count = @collection.stats(:director).fetch(@director)
      "«#{@title}» - Classic Movie, director: #{@director} (#{count} more movie#{count > 1 ? '' : 's'} in the list)."
    end
  end

  class ModernMovie < Movie
    def to_s
      "«#{@title}» - Modern Movie: starring #{@cast}."
    end
  end

  class NewMovie < Movie
    def to_s
      years = Date.today.year - @year.to_i
      "«#{@title}» - Brand-new Movie! Released #{years} year#{years > 1 ? '' : 's'} ago."
    end
  end
end