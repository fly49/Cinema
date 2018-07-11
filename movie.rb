class Movie
  attr_reader :link, :title, :year, :country, :date, :genre, :duration, :rating, :director, :cast
  GENRES = %w( Adventure Comedy Drama Fantasy Crime Thriller Biography Action)
  
  def initialize(params)
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

  def has_genre?(str)
    if @genre.include?(str)
      return true
    elsif GENRES.include?(str)
      return false
    else
      raise "Incorrect genre!"
    end
  end
  
end