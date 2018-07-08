require 'csv'
require 'date'
require_relative 'Movie'

class MovieCollection
  
  def initialize(name)
    abort("File doesn't exist!") unless File.file?(name)
    table = %w[ link title year country date genre duration rating director cast ]
    @database = CSV.read(name, col_sep:'|', :headers => table).map {|a| Movie.new(a.to_h)}
  end
  
  def all
    @database
  end
  
  def sort_by(param)
    raise("Wrong param!") unless @database[0].respond_to?(param)
    @database.sort_by(&param).first(5)
  end 
  
  def filter(hash)
    att = hash.keys[0]; val = hash.values[0]
    raise("Wrong param!") unless @database[0].respond_to?(att)
    @database.select { |film| film.send(att).include?(val)}.first(5)
  end
  
  def stats(param)
    raise("Wrong param!") unless @database[0].respond_to?(param) || param == :month
    if param == :month
      param = Proc.new { |d| Date::MONTHNAMES[d.date.split('-')[1].to_i] }
    end
    @database.map(&param).compact.each_with_object(Hash.new(0)) { |d, hash| hash[d] += 1 }
                                 .sort_by{ |k,v| v }.reverse.to_h
  end
end