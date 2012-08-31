describe 'Regu' do
  
  it 'should correctly handle bases' do
    base = Regu::NFA.base 'x'
    regu = Regu.compile r
    
    regu.accepts?('xy').should be_false
    
    for letter in 'A..z'
      regu.accepts?(letter).should == (letter == 'x')
    end
  end
  
  it 'should handle strings' do
    regu = Regu.string 'Hello World'
    
    regu.accepts?('Foo Bar Baz').should be_false
    regu.accepts?('Hello World').should be_true
    regu.accepts?('Hello').should be_false
  end
  
end