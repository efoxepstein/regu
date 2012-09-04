class PnDebug
  def self.log(*args)
    # puts *args
  end
end

class Object
  def inspecty
    puts "<inspection #{op.name}>"
    puts inspect
    puts "</inspection>"
    self
  end
end

module UnionNodeM
  def value
    PnDebug.log "union#value"
    
    nodes = [first_element].concat(rest_elements.elements.map(&:concat))
    Regu::Node.union nodes.map(&:value)
  end
end

module ConcatNodeM
  def value
    PnDebug.log "concat#value"

    Regu::Node.concat elements.map(&:value)
  end
end

module StarNodeM
  def value
    PnDebug.log "star#value"

    repeatable.value.star
  end
end

module RepeatNodeM
  def value
    PnDebug.log "repeat#value"
    nodes = reps.text_value.to_i.times.map { repeatable.value }

    Regu::Node.concat(nodes)
  end
end

module RepeatRangeNodeM
  def value
    PnDebug.log "repeat_range#value"
    lo, hi = low.text_value.to_i, high.text_value.to_i
    
    necessary = lo.times.map { repeatable.value }
    optional  = (hi-lo).times.map { repeatable.value.union Regu::Node.unit }

    combined = Array(necessary)+Array(optional)
    Regu::Node.concat combined
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

module CharNodeM
  def value
    PnDebug.log "char_node#value: #{text_value}"
    
    symbols = (0..127).map(&:chr).select {|x| /#{text_value}/ =~ x }
    Regu::Node.base(symbols)
  end
end


module ParenNodeM
  def value
    PnDebug.log "paren#value"
    regex.value
  end
end
