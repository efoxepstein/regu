module Regu
  module DFA
    def self.from_nfa(alphabet, nfa)
      queue = [[[], node, nfa.start_state.epsilon_closure]]
      pos = 0

      while pos < queue.size
        word, proxy, states = queue[pos]
        pos += 1
  
        for sym in alphabet
          can_reach = states.map{|x| x[sym]}.flatten.uniq.map(&:epsilon_closure).uniq
          proxy[sym] << (new_proxy = node)
          new_proxy.accepting = true if can_reach.any?(:accepting?)
          queue << [word + [sym], new_proxy, can_reach]
        end
      end
    
      dfa = NFA.new
      dfa.states = queue.map {|x| x[1] }
      dfa.start_state = dfa.states[0]
      dfa
    end
  
    def self.to_table(dfa)
      state_map = Hash[dfa.states.zip(0 .. dfa.states.size)]
      table = (0 .. dfa.states.size).map { "\x00" * 129 }
      
      for state, key in state_map
        table[key][128] = "\x01" if state.accepting?
        
        for sym, dest in state
          raise 'No epsilon allowed' if sym == Regu::EP
          table[key][sym.ord] = state_map[dest].chr
        end
      end
      
      table
    end
  end
end
