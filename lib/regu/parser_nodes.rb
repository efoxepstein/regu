class PnDebug
  def self.log(*args)
    # puts *args
  end
end

module UnionNodeM
  def value
    PnDebug.log "union#value"
    left.value.union(right.value)
  end
end

class UnionNode < Treetop::Runtime::SyntaxNode
  include UnionNodeM
end


module ConcatNodeM
  def value
    PnDebug.log "concat#value"
    elements.map(&:value).inject(&:concat)
  end
end

class ConcatNode < Treetop::Runtime::SyntaxNode
  include ConcatNodeM
end


module StarNodeM
  def value
    PnDebug.log "star#value"
    elements[0].value.star
  end
end

class StarNode < Treetop::Runtime::SyntaxNode
  include StarNodeM
end

module RepeatNodeM
  def value
    PnDebug.log "repeat#value"
    reps.text_value.to_i.times.map { repeatable.value }.inject(&:concat)
  end
end

module RepeatRangeNodeM
  def value
    PnDebug.log "repeat_range#value"
    lo, hi = low.text_value.to_i, high.text_value.to_i
    
    necessary = lo.times.map { repeatable.value }.inject(&:concat)
    optional  = (hi-lo).times.map { repeatable.value.union Regu::Node.unit }.inject(&:concat)

    if necessary.nil?
      optional
    else
      necessary.concat(optional)
    end
  end
end

module OptionalNodeM
  def value
    PnDebug.log "optional#value"
    repeatable.value.union Regu::Node.unit
  end
end

module PlusNodeM
  def value
    PnDebug.log "plus#value"
    elements[0].value.concat(elements[0].value.star)
  end
end

class PlusNode < Treetop::Runtime::SyntaxNode
  include PlusNodeM
end

module SymNodeM
  def value
    PnDebug.log "char_class#value"
    
    meat = terminal? ? text_value : elements[0].text_value
    
    # PnR meat
    
    (0..255).map(&:chr)
            .select {|x| /#{text_value}/ =~ x }
            .map {|x| Regu::Node.base x }
            .inject(&:union)
  end
end

class SymNode < Treetop::Runtime::SyntaxNode
  include SymNodeM
end

module ParenNodeM
  def value
    PnDebug.log "paren#value"
    regex.value
  end
end

class ParenNode < Treetop::Runtime::SyntaxNode
  include ParenNodeM
end
