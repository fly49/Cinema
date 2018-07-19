class Movie
  attr_reader :link, :title, :year, :country, :date, :genre, :duration, :rating, :director, :cast
  
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
    Date::MONTHNAMES[@date.split('-')[1].to_i] || "Unknown"
  end
  
  def duration
    @duration.chomp(" min").to_i
  end 
  
  def genre
    @genre.split(",")
  end
  
  def cast
    @cast.split(",")
  end
  
  def year
    @year.to_i
  end

  def has_genre?(str)
    raise("Incorrect genre!") unless @collection.genres.include?(str)
    @genre.include?(str)
  end
  
end
