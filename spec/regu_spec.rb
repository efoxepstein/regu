require './lib/regu'

describe 'Regu' do
  
  it 'should correctly handle bases' do
    base = Regu::NFA.base 'x'
    dfa  = Regu::DFA.from_nfa(base)
    regu = Regu::DFA.to_table(dfa)
    
    File.open('reg.dot', 'w') do |f|
      f.write dfa.to_dot
    end
        
    regu.accepts?('x').should be_true
    regu.accepts?('y').should be_false
    regu.accepts?('xy').should be_false
  end
  
  it 'should handle base concat' do
    base1 = Regu::NFA.base 'h'
    base2 = Regu::NFA.base 'i'
    
    concat = base1.concat base2
    
    # File.open('reg.dot', 'w') do |f|
    #   f.write concat.to_dot
    # end
    
    regu = Regu.compile concat

    regu.accepts?('hi').should be_true

    regu.accepts?('Foo Bar Baz').should be_false
    regu.accepts?('h').should be_false
    regu.accepts?('i').should be_false
  end
  
  it 'should handle strings' do
    regu = Regu.string 'Hello World'
    
    regu.accepts?('Foo Bar Baz').should be_false
    regu.accepts?('Hello World').should be_true
    regu.accepts?('Hello').should be_false
  end
  
  it 'should handle unions' do
    hello = Regu.string 'Hello', false
    world = Regu.string 'World', false
    union = hello | world
    
    regu = Regu.compile union
    
    regu.accepts?('Hello').should be_true
    regu.accepts?('World').should be_true
    regu.accepts?('').should be_false
    regu.accepts?('HelloWorld').should be_false
  end

  
end