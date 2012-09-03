require 'inline'

module Regu
  class Table < String
    attr_accessor :use_ruby, :state_diagram, :captures

    WORD_LENGTH = 129

    def initialize(states)  
      dfa = states.to_dfa

      state_map = Hash[dfa.each_with_index.to_a]      
      table = state_map.map { "\x00" * WORD_LENGTH }
      
      for state, key in state_map
        if state.accepting?
          table[key][WORD_LENGTH - 1] = "\x01"
        end
        
        for sym, dests in state.transitions
          raise 'No epsilon allowed' if sym == Regu::EP
          raise 'No nondeterminism' unless dests.size == 1
          table[key][sym.ord] = state_map[dests[0]].chr
        end        
      end
      
      @captures = []

      super(table.join)
    end
    
    def use_ruby?
      use_ruby
    end
        
    inline do |builder|
      
      builder.add_compile_flags '-std=c99'
      
      # builder.include '<stdio.h>;'

      c_accept = <<-END_C
        int c_accept(char *table, char *word, int len) {
          char state = 0;

          for (int i = 0; i < len; ++i) {
            state = table[(state * %d) + word[i]];
          }

          return table[((state+1) * %d) - 1];
        }
      END_C
      
      builder.c(c_accept % [WORD_LENGTH, WORD_LENGTH])
    end
    
    def r_accept(word)
      state = 0
      
      word.each_byte do |byte|
        state = self[state * WORD_LENGTH + byte].ord
      end
            
      self[(state+1) * WORD_LENGTH + -1].ord
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