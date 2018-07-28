# Fitness proportionate selection
module FitnessSelection
  def f_selection(hash)
    # Sort hash in ascending order
    hash_with_fits = hash.sort_by { |_k,v| v }.to_h
    # Sum of fitnesses
    sum_of_fits = hash_with_fits.reduce(0) { |sum,a| sum + a[1] }
    # Previous probability
    prev_prob = 0.0
    # Hash with weighted probabilitites
    h_probs = {}

    hash_with_fits.each do |key,val|
      h_probs[key] = prev_prob + (val / sum_of_fits)
      prev_prob = h_probs[key]
    end

    r = rand
    h_probs.each do |key, _v|
      return key if r < h_probs[key]
    end
  end
end
# puts f_selection({ "first": 5.1, "second": 8.5, "third": 6.0, "fourth": 7.0, "fifth": 7.5 })