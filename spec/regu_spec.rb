require './lib/regu'

describe 'Regu' do
  
  it 'should correctly handle bases' do
    regu = Regu::Node.base('x').compile
        
    regu.accepts?('x').should be_true
    regu.accepts?('y').should be_false
    regu.accepts?('xy').should be_false
  end
  
  it 'should handle base concat' do
    regu = Regu::Node.base('h').concat(Regu::Node.base('i')).compile

    regu.accepts?('hi').should be_true

    regu.accepts?('Foo Bar Baz').should be_false
    regu.accepts?('h').should be_false
    regu.accepts?('i').should be_false
  end
  
  it 'should handle strings' do
    regu = Regu.string('Hello World').compile
    
    regu.accepts?('Foo Bar Baz').should be_false
    regu.accepts?('Hello World').should be_true
    regu.accepts?('Hello').should be_false
  end
  
  it 'should be order-agnostic sometimes' do
    a, b, c = ('a'..'c').map {|x| Regu.string(x)}
    
    alpha = a.concat(b).concat(c).compile
    beta = a.concat(b.concat(c)).compile
    
    alpha == beta
  end
  
  it 'should handle unions' do
    hello = Regu.string('Hello')
    world = Regu.string('World')
    
    regu = hello.union(world).compile
    
    regu.accepts?('Hello').should be_true
    regu.accepts?('World').should be_true
    regu.accepts?('').should be_false
    regu.accepts?('HelloWorld').should be_false
  end
  
  it 'should handle stars' do
    prefix = Regu.string 'I am '
    very = Regu.string 'very, '
    suffix = Regu.string 'very happy'
    
    regu = prefix.concat(very.star).concat(suffix).compile
    
    regu.accepts?('I am very happy').should be_true
    regu.accepts?('I am very, very happy').should be_true
    regu.accepts?('I am very, very, very, very, very happy').should be_true
    
    regu.accepts?('I am').should be_false
    regu.accepts?('very happy').should be_false
    regu.accepts?('').should be_false
  end

  
end