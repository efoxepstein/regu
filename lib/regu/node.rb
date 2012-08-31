module Regu

  EP = Object.new
  def EP.to_s
    'EP'
  end

  class Node < Hash
    attr_accessor :accepting
  
    def initialize(accept = false)
      self.accepting = accept
      super() {|h,k| h[k] = [] }
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
  end
end