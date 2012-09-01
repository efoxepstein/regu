require 'set'

require 'regu/version'
require 'regu/node'
require 'regu/state'
require 'regu/table'
require 'regu/parser'

module Regu  
  def self.string(str)
    r = str.each_char
           .map {|x| Regu::Node.base x}
           .inject(&:concat)
  end
end
