require 'csv'
require 'date'
require_relative 'movie'

class MovieCollection
  TABLE = %w[ link title year country date genre duration rating director cast ]
  
  def initialize(name)
    raise("File doesn't exist!") unless File.file?(name)
    @database = CSV.read(name, col_sep:'|', :headers => TABLE).map {|a| Movie.new(a.to_h)}
  end
  
  def all
    @database
  end
  
  def sort_by(param)
    raise("Wrong param!") unless @database[0].respond_to?(param)
    @database.sort_by(&param).first(5)
  end 
  
  def filter(hash)
    p hash
    att = hash.keys[0]; val = hash.values[0]
    raise("Wrong param!") unless @database[0].respond_to?(att)
    val = Regexp.new("#{val}(.*)") if val.respond_to?(:to_str)
    @database.select { |film| val === film.send(att) }.first(5)
  end
  
  def stats(param)
    raise("Wrong param!") unless @database[0].respond_to?(param)
    @database.map{ |d| d.send(param).split(',') }.flatten
             .each_with_object(Hash.new(0)) { |d, hash| hash[d] += 1 }
             .sort_by{ |k,v| v }.reverse.to_h
  end
end