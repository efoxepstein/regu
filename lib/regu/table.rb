require 'inline'

module Regu
  class Table < String
    
    def initialize(states)

      # File.open('nfa.dot', 'w') do |f|
      #        f.write states.to_dot
      #      end
      #      
      dfa = states.to_dfa
      # File.open('dfa.dot', 'w') do |f|
      #   f.write states.to_dot
      # end

      state_map = Hash[dfa.each_with_index.to_a]      
      table = state_map.map { "\x00" * 129 }
      
      for state, key in state_map
        
        if state.accepting?
          table[key][128] = "\x01"
        end
        
        for sym, dests in state.transitions
          raise 'No epsilon allowed' if sym == Regu::EP
          raise 'No nondeterminism' unless dests.size == 1
          table[key][sym.ord] = state_map[dests[0]].chr
        end        
      end

      super(table.join)
    end
    
    attr_accessor :use_ruby, :state_diagram
    def use_ruby?
      use_ruby
    end
        
    inline do |builder|
      
      builder.add_compile_flags '-std=c99'
      
      builder.include '<stdio.h>;'

      builder.c <<-END_C
        int c_accept(char *table, char *word, int len) {
          char state = 0;

          for (int i = 0; i < len; ++i) {
            state = table[(state * 129) + word[i]];
          }

          return table[(state * 129) + 128];
        }
      END_C
    end
    
    def r_accept(word)
      state = 0
      
      word.each_byte do |byte|
        # print "From %d, via %d " % [state, byte]
        state = self[state * 129 + byte].ord
        # puts "to %d" % state
      end
      
      # puts "Checking byte %d" % (state * 129 + 128)
      # puts "It is %d" % self[state * 129 + 128].ord
            
      self[state * 129 + 128].ord
    end
      
    def accepts?(word)      
      if use_ruby?
        r_accept(word)
      else
        c_accept(self, word, word.size)
      end != 0
    end

    def inspect
      each_byte.to_a.inspect
    end
  end
end