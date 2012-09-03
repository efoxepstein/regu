describe 'the parser' do
  
  it 'should parse base' do
    Regu['a'].should == Regu.string('a').compile
  end
  
  let(:hello) { Regu.string('Hello') }
  let(:jello) { Regu.string('Jello') }
  let(:world) { Regu.string('World') }
  
  
  it 'should parse simple things' do
    Regu['Hello'].should == hello.compile
  end
  
  it 'should parse reasonably complex regexps' do
    
    pairs = {
      'Hello'                => hello,
      '(Hello|World)*'       => (hello | world).star,
      'Hello|Worlds*'        => hello | (world - Regu.string('s').star),
      'Jello(Hello|World)*'  => jello - (hello | world).star,
      'Jello|Hello|Jello'    => jello | hello,
      'Jello|Jello|Jello'    => jello,
      'JelloJello'           => jello-jello
    }
    
    for left, right in pairs
      Regu[left].should == right.compile
    end
  end
  
  it 'should be able to get a long one' do
    str = '(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)'
    ab = Regu.string('a').union(Regu.string('b'))
    abs = ab.star
    Regu[str].should == (ab-abs-ab-abs-ab-abs-ab-abs-ab-abs-ab-abs-ab-abs-ab).compile
  end
  
end