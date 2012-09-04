module Regu
  
  class Node
    attr_accessor :op, :children
    
    def initialize(oper, *args)
      @op = oper
      @children = Array(args).flatten
    end
    
    def to_state_graph
      op.apply(*children)
    end
    
    def to_s
      op.to_s(*children)
    end
    
    #####
    
    def self.unit
      Node.new(UnitOp)
    end
    
    def self.base(symbols)
      Node.new(BaseOp, symbols)
    end

    def self.union(nodes)
      Node.new(UnionOp, Array(nodes))
    end
    
    def self.concat(nodes)
      Node.new(ConcatOp, nodes)
    end
    
    #####

    def star
      Node.new(StarOp, self)
    end
    
    def union(others)
      Node.union([self] + Array(others))
    end
    alias_method :|, :union
    
    def concat(others)
      Node.concat([self] + Array(others))
    end
    alias_method :-, :concat
    
    def compile
      Regu::Table.new(to_state_graph)
    end
  end
  
  class UnitOp
    def self.apply
      State.new(true)
    end
    
    def self.to_s
      '_'
    end
  end
  
  class BaseOp
    def self.apply(*symbols)
      terminal = State.new(true)
      
      State.new(false).tap do |s|        
        for sym in symbols
          s[sym] << terminal
        end
      end
    end
    
    def self.to_s(*symbols)
      if symbols.size == 1
        symbols[0]
      else
        '(' + symbols.join('|') + ')'
      end
    end
  end
  
  class StarOp
    def self.apply(child)
      child.to_state_graph.wrap.tap do |state|
        acceptor = state.detect {|s| s.accepting? }
        acceptor[EP] << state
        state[EP] << acceptor
      end   
    end
    
    def self.to_s(child)
      "%s*" % child
    end
  end
  
  class UnionOp
    def self.apply(*states)      
      State.new(false).tap do |s|
        s[EP].concat(states.map(&:to_state_graph))
      end
    end
    
    def self.to_s(*states)
      '(' + states.map(&:to_s).join(' | ') + ')'
    end
  end
  
  class ConcatOp
    def self.apply(*nodes)
      states = nodes.map &:to_state_graph

      first = states.first
      
      until states.size == 1
        head = states.shift
        tail = states.first
        
        head.select(&:accepting).each do |s|
          s.accepting = false
          s[EP] << tail
        end
      end
      
      first
    end
    
    def self.to_s(*nodes)
      '(' + nodes.map(&:to_s).join + ')'
    end
  end
end