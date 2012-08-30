require 'regu/version'
require 'regu/regu'
require 'set'

module Regu

  EP = Object.new

  class Node < Hash
    attr_accessor :accepting
  
    def initialize(accept = false)
      self.accepting = accept
      super {|h,k| h[k] = Set.new }
    end
  
    def accepting?
      !! self.accepting
    end
  
    def epsilon_closure
      states = [self]
      i = 0
      while i < states.size
        states += states[i][EP]
        i += 1
      end
      states
    end
  end

  def node
    Node.new
  end


  class AFA
    attr_accessor :start_state, :states
  
    def initialize
      self.states = []
    end
  
    def accepting_states
      states.select(&:accepting)
    end
  
    def self.base(letter)
      nfa = AFA.new
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
    
      nfa = AFA.new
    
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
      nfa = AFA.new
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
      nfa = AFA.new
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

  module DFA
    def self.from_NFA(alphabet, nfa)
      queue = [[[], node, nfa.start_state.epsilon_closure]]
      pos = 0

      until pos < queue.size
        word, proxy, states = queue[pos]
        pos += 1
  
        for sym in alphabet
          can_reach = states.map{|x| x[sym]}.flatten.uniq.map(&:epsilon_closure).uniq
          proxy[sym] << (new_proxy = node)
          new_proxy.accepting = true if can_reach.any?(:accepting?)
          queue << [word + [sym], new_proxy, can_reach]
        end
      end
    
      dfa = FA.new
      dfa.states = queue.map {|x| x[1] }
      dfa.start_state = dfa.states[0]
      dfa
    end
  
    def self.to_table(nfa)
    
    end
  end
end
