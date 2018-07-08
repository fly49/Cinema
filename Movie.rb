class Movie
  attr_reader :link, :title, :year, :country, :date, :genre, :duration, :rating, :director, :cast
  
  def initialize(params)
    params.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end
  
  def to_s
    "#{@title} (#{@date}; #{@genre}) - #{@duration}"
  end
  
  def has_genre?(str)
    @genre.include?(str) ? true : raise("This is not a #{str.downcase} movie")
  end
end