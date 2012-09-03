module UnionNodeM
  def value
    # puts "union#value"
    left.value.union(right.value)
  end
end

class UnionNode < Treetop::Runtime::SyntaxNode
  include UnionNodeM
end

module ConcatNodeM
  def value
    # puts "concat#value"
    elements.map(&:value).inject(&:concat)
  end
end

class ConcatNode < Treetop::Runtime::SyntaxNode
  include ConcatNodeM
end

module StarNodeM
  def value
    # puts "star#value"
    elements[0].value.star
  end
end

class StarNode < Treetop::Runtime::SyntaxNode
  include StarNodeM
end

module SymNodeM
  def value
    # # puts "sym#value: #{text_value}"
    Regu::Node.base text_value.to_s[-1]
  end
end

class SymNode < Treetop::Runtime::SyntaxNode
  include SymNodeM
end

module ParenNodeM
  def value
    # puts "paren#value"
    regex.value
  end
end

class ParenNode < Treetop::Runtime::SyntaxNode
  include ParenNodeM
end
