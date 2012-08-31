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

end