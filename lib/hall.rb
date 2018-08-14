require 'virtus'

module Cinema
  class Hall
    include Virtus.model

    attribute :color, Symbol
    attribute :title, String
    attribute :places, Integer
  end
end