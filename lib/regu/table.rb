module Regu  
  class Table
    attr_accessor :use_ruby, :packed, :table

    WORD_LENGTH = 129

    def initialize(states)  
      dfa = states.to_dfa
      
      state_list = dfa.each_with_index.map {|s, i| s.uid = i; s }

      @table = state_list.map { [0] * WORD_LENGTH }
      
      for state in state_list
        if state.accepting?
          @table[state.uid][WORD_LENGTH - 1] = 1
        end
        
        for sym, dests in state.transitions
          raise 'No epsilon allowed' if sym == Regu::EP
          raise 'No nondeterminism' unless dests.size == 1
          @table[state.uid][sym.ord] = dests[0].uid
        end        
      end

      @packed = @table.map {|x| x.pack('S*') }.join
    end
    
    def use_ruby?
      use_ruby
    end
        
    inline do |builder|
      
      builder.add_compile_flags '-std=c99'

      c_accept = <<-END_C
        int c_accept(char *table, char *word, int len) {
          uint16_t state = 0;
          
          uint16_t *real_table = (uint16_t *) table;

          for (int i = 0; i < len; ++i) {
            state = real_table[(state * %d) + word[i]];
          }

          return real_table[((state+1) * %d) - 1];
        }
      END_C
      
      builder.c(c_accept % [WORD_LENGTH, WORD_LENGTH])
    end
    
    def r_accept(word)
      state = 0
      
      word.each_byte do |byte|
        state = @table[state][byte]
      end
            
      @table[state][WORD_LENGTH - 1]
    end
      
    def accepts?(word)      
      if @use_ruby
        r_accept(word)
      else
        c_accept(packed, word, word.size)
      end != 0
    end    
    alias_method :=~, :accepts?

    def ==(other)
      table == other.table
    end

    def inspect
      table.inspect
    end
  end
end