describe 'the parser' do
  
  xit 'should parse base' do
    Regu['a'].should == Regu.string('a').compile
  end
  
  let(:hello) { Regu.string('Hello') }
  let(:jello) { Regu.string('Jello') }
  let(:world) { Regu.string('World') }
  
  
  xit 'should parse simple things' do
    Regu['Hello'].should == hello.compile
  end
  
  it 'should parse something reasonably complex' do
    
    pairs = {
      # 'Hello'               => hello,
      '(Hello|World)*'      => (hello | world).star,
      # 'Hello|World*'        => hello | (world.star),
      # 'Jello(Hello|World)*' => jello - (hello | world).star
    }
    
    for left, right in pairs
      Regu[left].should == right.compile
    end
  end
  
end