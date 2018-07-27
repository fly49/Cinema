require_relative 'movie_collection'

class Theatre < MovieCollection
  SCHEDULE = { morning: { period: [:ancient] }, noon: { genre: ["Adventure",'Comedy'] }, evening: { genre: ['Drama','Horror'] } }
    
  def show(time)
    key, value = SCHEDULE[time].first
    self.filter( Hash[key,value.sample] ).sample
  end
  def when?(name)
    SCHEDULE.each do |time, _hash|
      key, value = SCHEDULE[time].first
      return time if Array(self.find(name).send(key)).any? { |val| value.include?(val) }
    end
  end
end