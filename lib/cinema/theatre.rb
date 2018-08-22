require_relative 'movie_collection'

module Cinema
  class Theatre < MovieCollection
    include Cashbox

    def initialize(file, &block)
      super file
      raise 'You need a block to build a theatre!' unless block_given?
      instance_eval(&block)
      raise 'Time ranges overlap!' if ranges_overlap?(periods.keys)
    end

    class Hall
      include Virtus.model

      attribute :color, Symbol
      attribute :title, String
      attribute :places, Integer
    end

    class Period
      attr_reader :time

      def initialize(time)
        @time = time
      end

      def description(data = nil)
        @description ||= data
      end

      def filters(data = nil)
        @filters ||= data
      end

      def price(data = nil)
        @price ||= data
      end

      def hall(*data)
        @hall ||= data
      end

      def title(name = nil)
        @title ||= filters(title: name)
      end
    end

    def hall(color,hash)
      halls[color] = Hall.new(color: color, **hash)
    end

    def period(time,&block)
      raise 'You need a block to build a period!' unless block_given?
      periods[time] = Period.new(time)
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