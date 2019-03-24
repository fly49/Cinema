require 'virtus'

# Movie's gerne contains several genres
class ArrOfStr < Virtus::Attribute
  def coerce(value)
    value.split(',')
  end
end

# Movie's duration stores in minutes
class Minutes < Virtus::Attribute
  def coerce(value)
    value.chomp(' min').to_i
  end
end

module Cinema
  # Contains information about specific movie and provides it in convinient form
  class Movie
    include Virtus.model

    attribute :link, String
    attribute :title, String
    attribute :rus_title, String
    attribute :year, Integer
    attribute :country, String
    attribute :date, String
    attribute :genre, ArrOfStr
    attribute :duration, Minutes
    attribute :rating, Float
    attribute :director, String
    attribute :cast, ArrOfStr
    attribute :img_url, String
    attribute :budget, String

    def self.create(attr_hash)
      case attr_hash[:year].to_i
      when 1900..1945
        AncientMovie.new(attr_hash)
      when 1945..1968
        ClassicMovie.new(attr_hash)
      when 1968..2000
        ModernMovie.new(attr_hash)
      else
        NewMovie.new(attr_hash)
      end
    end

    def initialize(attr_hash)
      super attr_hash
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

    def has_genre?(str)
      @genre.include?(str)
    end
  end

  class AncientMovie < Movie
    def to_s
      "«#{@title}» - Old Movie (#{@year})."
    end
  end

  class ClassicMovie < Movie
    def to_s
      "«#{@title}» - Classic Movie, director: #{@director}."
    end
  end

  class ModernMovie < Movie
    def to_s
      "«#{@title}» - Modern Movie: starring #{@cast.join(", ")}."
    end
  end

  class NewMovie < Movie
    def to_s
      years = Date.today.year - @year.to_i
      "«#{@title}» - Brand-new Movie! Released #{years} year#{years > 1 ? '' : 's'} ago."
    end
  end
end
