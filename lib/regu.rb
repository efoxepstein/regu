require 'set'
require 'inline'
require 'fileutils'
require 'digest/sha1'
require 'treetop'

require 'regu/version'

require 'regu/node'
require 'regu/state'
require 'regu/table'

require 'regu/core_ext/regexp'

require 'regu/parser_nodes'
require 'regu/parser'

module Regu  
  def self.string(str)
    r = str.each_char
           .map {|x| Regu::Node.base x}
           .inject(&:concat)
  end
end
