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
      a[letter] << b
      b.accepting = true
      nfa.start_state = a
      nfa.states << a << b
      nfa
    end
  
    def wrap
      new_start, new_accept = node, node
      new_start[EP] << start_state
      new_accept.accepting = true
    
      nfa = NFA.new

      nfa.states = [new_start, new_accept] + states

      nfa.start_state = new_start
    
      for state in accepting_states
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
    alias_method :|, :union
  
    def star
      wrap.tap do |nfa|
      
        raise 'Must have one accepting state' if nfa.accepting_states.size != 1
        acceptor = nfa.accepting_states.first
      
        acceptor[EP] << nfa.start_state
        nfa.start_state[EP] << acceptor
      
      end
    end
  
    def concat(nfa2)
      nfa = NFA.new
      nfa1 = self.wrap
      nfa2 = nfa2.wrap
    
      nfa.states += nfa1.states      
      nfa.states += nfa2.states
    
      for state in nfa1.accepting_states
        state.accepting = false
        state[EP] << nfa2.start_state
      end
      
      nfa.start_state = nfa1.start_state
    
      nfa
    end
    alias_method :-, :concat
    
    def to_dot
      dot = ['digraph G {']
      
      dot << "\t#{start_state.uid} [shape=\"doublecircle\"];"

      for state in states
        if state.accepting?
          dot << "\t#{state.uid} [color=\"green\"];"
        end
        for sym, dests in state
          for dest in dests
            dot << "\t#{state.uid} -> #{dest.uid} [label=\"#{sym}\"];"
          end
        end
      end
      
      dot << '}'
      dot.join("\n")
    end
    
    private
    def self.node
      Node.new
    end
    def node
      self.class.node
    end
  end
end