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
  
  it 'should handle optional things' do
    s = Regu.string('s')
    ss = s.union(Regu::Node.unit)
    
    Regu['Jellos?'].should == jello.concat(ss).compile
    Regu['s?s?s?s'].should == (ss-ss-ss-s).compile
    Regu['(Jello|Hello)?World'].should == (jello.union(hello).union(Regu::Node.unit)-world).compile
  end
  
  it 'should handle plus' do
    Regu['(a|b)+'].should == Regu['(a|b)(a|b)*']
  end
  
  it 'should handle ranges' do
    Regu['a{0,1}'].should == Regu.string('a').concat(Regu::Node.unit).compile
    Regu['a{0,1}'].should == Regu['a?']
    Regu['(abc){3,4}'].should == Regu['(abc)(abc)(abc)(abc)?']
    Regu['ab{3}c'].should == Regu['abbbc']
  end
  
  
  it 'should handle character classes' do
    Regu['[abc]'].should == Regu['(a|b|c)']
    expect {
      Regu['[\]]'].accepts? ']'
    }.to be_true
  end
  
  it 'should handle escapes' do
    /\{/.regu.should == Regu.string('{').compile
    /\(/.regu.should == Regu.string('(').compile
  end
  
  it 'should handle dots' do
    /./.regu.accepts?('*').should be_true
  end
end