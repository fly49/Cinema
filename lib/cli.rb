require 'irb'

module Cinema
  def self.start
    # Auto-Completion
    comp = proc { |s| Readline::HISTORY.grep(/^#{Regexp.escape(s)}/) }
    Readline.completion_proc = comp
    
    # Handle Ctrl-C
    stty_save = `stty -g`.chomp
    trap('INT') do
      system('stty', stty_save)
      exit
    end 
    
    netflix = Cinema::Netflix.new('data/movies.txt')
    
    while input = Readline.readline("> ", true)
      case input
      when "exit"
        puts "Goodbye!"
        break
      when "history"
        puts Readline::HISTORY.to_a
      end
      
      # Remove blank lines from history
      Readline::HISTORY.pop if input == ""
      system(input)
    end
  end
end
