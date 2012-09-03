module Regu
  
  class Node
    attr_accessor :op, :children
    
    def initialize(oper, *args)
      @op = oper
      @children = args
    end
    
    def to_state_graph
      op.apply(*children)
    end
    
    def to_s
      op.to_s(*children.map(&:to_s))
    end
    
    def self.unit
      Node.new(UnitOp)
    end
    
    def self.base(sym)
      Node.new(BaseOp, sym)
    end

    def star
      Node.new(StarOp, self)
    end
    
    def union(other)
      Node.new(UnionOp, self, other)
    end
    alias_method :|, :union
    
    def concat(other)
      Node.new(ConcatOp, self, other)
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
    def self.apply(symbol)
      State.new(false).tap do |s|
        s[symbol] << State.new(true)
      end
    end
    
    def self.to_s(c)
      "%s" % c
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
    
    def self.to_s(c)
      "%s*" % c
    end
  end
  
  class UnionOp
    def self.apply(left, right)
      State.new(false).tap do |s|
        s[EP] << left.to_state_graph << right.to_state_graph
      end
    end
    
    def self.to_s(l, r)
      "(%s | %s)" % [l, r]
    end
  end
  
  class ConcatOp
    def self.apply(left, right)
      head, tail = left.to_state_graph.wrap, right.to_state_graph.wrap

      head.select(&:accepting).each do |s|
        s.accepting = false
        s[EP] << tail
      end
      
      head
    end
    
    def self.to_s(l, r)
      "(%s%s)" % [l, r]
    end
  end
end