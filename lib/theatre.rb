require_relative 'movie_collection'

class Theatre < MovieCollection
  SCHEDULE = { morning: { period: :ancient },
               noon: { genre: /(Adventure|Comedy)/ },
               evening: { genre: /(Drama|Horror)/ },
               special: { genre: /(Comedy|Drama)/, cast: /Al Pacino/ } }.freeze

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
end