module Regu
  class NFA
    attr_accessor :start_state, :states
  
    def initialize
      self.states = []
    end
  
    def accepting_states
      states.select(&:accepting)
    end
  
    def self.base(letter)
      nfa = NFA.new
      a, b = node, node
      a[letter] << node
      b.accepting = true
      nfa.start_state = a
      nfa.states << a << b
      nfa
    end
  
    def wrap
      new_start, new_accept = node, node
      new_start[EP] << @start_state
      new_accept.accepting = true
    
      nfa = NFA.new
    
      nfa.states << new_start << new_end
      nfa.start_state = new_start
    
      for state in accepting_states
        nfa.states << state
        state.accepting = false
        state[EP] << new_accept
      end

      nfa
    end
  
    def union(nfa2)
      a = node
      a[EP] << self.start_state << nfa2.start_state
      nfa = NFA.new
      nfa.start_state = a
      nfa.states << a
      nfa.states += self.states
      nfa.states += nfa2.states
      nfa
    end
  
    def star
      nfa = wrap
      for state in nfa.accepting_states
        state[EP] << nfa.start_state
      end
      nfa
    end
  
    def concat(nfa2)
      nfa = NFA.new
      nfa1 = self.wrap
      nfa2 = nfa2.wrap
    
      nfa.states += nfa1.states
      nfa.states += nfa2.states
    
      for state in nfa1.accepting_states
        state[EP] << nfa2.start_state
      end
    
      nfa
    end
  end
end