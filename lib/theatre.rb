require_relative 'movie_collection'
module Cinema
  class Theatre < MovieCollection
    include Cashbox
    SCHEDULE = { morning: { period: :ancient },
                 noon: { genre: /(Adventure|Comedy)/ },
                 evening: { genre: /(Drama|Horror)/ },
                 special: { genre: /(Comedy|Drama)/, cast: /Al Pacino/ } }.freeze
    PRICE_LIST = { morning: 3.0, noon: 5.0, evening: 10.0 }.freeze

    def show(time)
      raise('Incorrect time!') unless SCHEDULE.key?(time)
      movie = filter(SCHEDULE[time]).max_by { |m| m.rating * rand }
      super movie
    end

    def when?(name)
      SCHEDULE.find do |time, _hash|
        key, value = SCHEDULE[time].first
        Array(find(name).send(key)).any? { |i| value === i }
      end.first
    end

    def buy_ticket(name)
      movie = find(name)
      add_money(PRICE_LIST[when?(movie.title)])
      "You\'ve bought a ticket for the movie «#{movie.title}»."
    end
  end
end