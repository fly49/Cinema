# Movie contains information about specific movie and provides it in convinient form.
class Movie
  attr_reader :link, :title, :country, :date, :director
  
  def self.create(array, collection)
    data = array.to_h
    case data["year"].to_i
    when 1900..1945
      AncientMovie.new(data, collection)
    when 1945..1968
      ClassicMovie.new(data, collection)
    when 1968..2000
      ModernMovie.new(data, collection)
    else
      NewMovie.new(data, collection)
    end
  end

  def initialize(params, collection)
    @collection = collection
    params.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def to_s
    "#{@title} (#{@date}; #{@genre}) - #{@duration}"
  end

  def month
    Date::MONTHNAMES[@date.split('-')[1].to_i] || 'Unknown'
  end

  def duration
    @duration.chomp(' min').to_i
  end

  def genre
    @genre.split(',')
  end

  def cast
    @cast.split(',')
  end

  def year
    @year.to_i
  end
  
  def rating
    @rating.to_f
  end
  
  def period
    self.class.name.chomp('Movie').downcase.to_sym
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
    count = @collection.stats(:director).select { |key| key == @director }.values.first
    "«#{@title}» - Classic Movie, director: #{@director} (#{count} more movie#{ count > 1 ? "":"s" } in the list)."
  end
end

class ModernMovie < Movie
  def to_s
    "«#{@title}» - Modern Movie: starring #{@cast}."
  end
end

class NewMovie < Movie
  def to_s
    years = Date::today.year - @year.to_i
    "«#{@title}» - Brand-new Movie! Released #{years} year#{ years > 1 ? "":"s" } ago."
  end
end