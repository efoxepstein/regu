module Regu
  module DFA
    def self.from_nfa(nfa)
      alphabet = (0..127).map(&:chr)
      pos = 0
      queue = {nfa.start_state.epsilon_closure => Node.new}

      while pos < queue.size
        states = queue.keys[pos]
        proxy = queue[states]
        pos += 1
        
        # puts "Processing #{proxy.uid} (#{states.map(&:uid).inspect})"
  
        for sym in alphabet
          can_reach = states.map{|x| x[sym]}
                            .flatten.uniq
                            .map(&:epsilon_closure)
                            .flatten.uniq
          
          # puts "\t via #{sym.ord} it can reach #{can_reach.map(&:uid).inspect}"
          
          next if can_reach.empty? 
          
          unless queue.key? can_reach
            queue[can_reach] = Node.new(can_reach.any?(&:accepting?))
          end

          proxy[sym] << queue[can_reach]
        end
      end
    
      dfa = NFA.new
      dfa.states = queue.values
      dfa.start_state = dfa.states[0]
      dfa
    end
  
    def self.to_table(dfa)
      state_map = Hash[dfa.states.zip(0 ... dfa.states.size)]      
      table = (0 ... dfa.states.size).map { "\x00" * 129 }
      
      for state, key in state_map
        if state.accepting?
          table[key][128] = "\x01"
        end
        
        for sym, dests in state
          raise 'No epsilon allowed' if sym == Regu::EP
          raise 'No nondeterminism' unless dests.size == 1
          table[key][sym.ord] = state_map[dests[0]].chr
        end        
      end

      Table.new(table.join)
    end
  end
end
