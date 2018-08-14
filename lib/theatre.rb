require_relative 'movie_collection'
require_relative 'hall'
require_relative 'period'

module Cinema
  class Theatre < MovieCollection
    include Cashbox

    def initialize(file, &block)
      super file
      raise 'You need a block to build a theatre!' unless block_given?
      instance_eval(&block)
      raise 'Time ranges overlap!' if ranges_overlap?(periods.keys)
    end

    def hall(color,hash)
      halls[color] = Cinema::Hall.new(color: color, **hash)
    end
    
    def period(time,&block)
      raise 'You need a block to build a period!' unless block_given?
      periods[time] = Cinema::Period.new(time)
      periods[time].instance_eval(&block)
    end

    def halls
      @halls ||= {}
    end

    def periods
      @periods ||= {}
    end

    def show(time,hall = nil)
      sessions = periods.values.find_all { |prd| prd.time === time }
      raise('Incorrect time!') if sessions.empty?
      if sessions.length > 1
        raise 'Please specfy the hall!' if hall.nil?
        seance = sessions.select { |prd| Array(prd.hall).include?(hall) }.first
      else
        seance = sessions.first
      end
      movie = filter(seance.filters).max_by { |m| m.rating * rand }
      add_money(seance.price)
      puts "You\'ve bought a ticket for the movie «#{movie.title}»."
      movie
    end

    private

    def ranges_overlap?(array_of_ranges)
      array_of_ranges.sort_by(&:first).each_cons(2).any? do |x,y|
        x.last > y.first && !(Array(periods[x].hall) & Array(periods[y].hall)).empty?
      end
    end
  end
end