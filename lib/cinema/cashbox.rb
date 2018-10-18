require 'money'
I18n.enforce_available_locales = false  # money gem requires it
  
module Cinema
  # Imitates cinema's owner credit account
  module Cashbox
    def cash
      @cash ||= Money.new(0, 'USD')
    end
  
    def add_money(val)
      self.cash += Money.new(val * 100, 'USD')
    end
  
    def take(who)
      raise 'It is illegal!' unless who == 'bank'
      @cash = Money.new(0, 'USD')
      puts 'Encashment has been carried out'
    end
  
    private
  
    def cash=(val)
      @cash = Money.new(val, 'USD')
    end
  end
end