module Cinema
  class Period
    attr_reader :time

    def initialize(time)
      @time = time
    end
    
    def description(data=nil)
      @description ||= data
    end
    
    def filters(data=nil)
      @filters ||= data
    end
    
    def price(data=nil)
      @price ||= data
    end
    
    def hall(*data)
      @hall ||= data
    end
    
    def title(name=nil)
      @title ||= filters(title: name)
    end
  end
end    