require 'set'

module Regu

  EP = Object.new
  def EP.to_s
    'EP'
  end

  class State    
    def self.traverse(s)
      seen = Set.new
      stack = [s]
      until stack.empty?
        top = stack.pop        
        yield top
        
        for state in top.transitions.values.flatten
          unless seen.include? state
            stack << state
            seen << state
          end
        end
      end
    end
    
    attr_accessor :accepting, :transitions

    def initialize(accept = false)
      @accepting = accept
      @transitions = Hash.new {|h,k| h[k] = [] }
    end
    
    def [](*args)
      transitions[*args]
    end
    
    def each(&blk)
      State.traverse(self, &blk)
    end
    include Enumerable
  
    def accepting?
      !! self.accepting
    end
  
    def epsilon_closure
      states = Set.new
      stack = [self]
      
      until stack.empty?
        top = stack.pop
        
        unless states.include? top
          states << top
          stack += top[EP]
        end
      end

      states.to_a
    end
    
    def wrap
      new_start, new_accept = State.new, State.new

      State.traverse(self) do |s|
        if s.accepting?
          s.accepting = false
          s[EP] << new_accept
        end
      end
      
      new_start[EP] << self      
      new_accept.accepting = true
      
      new_start
    end
    
    def to_s
      object_id
    end
    def inspect
      to_s
    end
    
    def uid
      @uid ||= begin
        @@uid ||= 0
        @@uid += 1
        "s#{@@uid}"
      end
    end
    
    def to_dot
      dot = ['digraph G {']
      
      dot << "\t#{uid} [shape=\"doublecircle\"];"

      each do |state|
        if state.accepting?
          dot << "\t#{state.uid} [color=\"green\"];"
        end
        for sym, dests in state.transitions
          for dest in dests
            dot << "\t#{state.uid} -> #{dest.uid} [label=\"#{sym}\"];"
          end
        end
      end

      dot << '}'
      dot.join("\n")
    end
    
    def to_dfa
      alphabet = (0..127).map(&:chr)
      pos = 0
      queue = {epsilon_closure => State.new}

      while pos < queue.size
        states, proxy = queue.keys[pos], queue.values[pos]
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
            queue[can_reach] = State.new(can_reach.any?(&:accepting?))
          end

          proxy[sym] << queue[can_reach]
        end
      end
      
      queue.values[0]
    end
  end
end