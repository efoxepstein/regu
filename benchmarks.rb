require './lib/regu'
require 'benchmark'

def test(regular_expression, test_cases)
  hits = 0
  1000.times do
    for test in test_cases
      hits += 1 if regular_expression =~ test
    end
  end
  hits
end

def benchmark(regexp, tests)  
  regu = regexp.cached_regu
  

  native = Benchmark.realtime { test(regexp, tests) }
  
  regu.use_ruby = false
  regu_c = Benchmark.realtime { test(regu, tests) }
  
  regu.use_ruby = true
  regu_rb = Benchmark.realtime { test(regu, tests) }
  
  [native, regu_c, regu_rb]
end

regexps = {
  '(red|green|blue)*(red|blue)*((blue)*|(green)*)(green|red)*' => 
    %w[
      redredredredbluebluegreengreenredredredred
      blueblueblueblueblueblueredgreenblue
      blueblueblueblueblueblueredgreenblueblueblueblueblueblueblueredgreenblueblueblueblueblueblueblueredgreenblueblueblueblueblueblueblueredgreenblueredredredred
    ],
  '(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*b+'*3 =>
    %w[
      aaaaaaaaaaaaaaa
      aababababababababbbabbabababababcababbabababababababababbabababababababbabab
      aabababbabababababababababababababababababbababababababababbabababababababaababbac
      abababbabababababababababababababbabababcababababababababababbabababababababababababbabababababaabab
      cbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
      bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
    ],
  '[abcdef]{2,3}b*[abcdef]*[abcdef]{2,3}b{2,3}'*3 =>
    %w[
      aabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccbbaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccbbaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccbb
      bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbfffbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbfffbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbfffbb
      aaccbbaaccbb
    ],
  '.*<div (class="([a-zA-Z0-9_-]+[ ]+)*")?><a href="[^"]+">[a-zA-Z0-9 ]+</a></div>.*' =>
    [
      'alskjfasfka fajkfl akjfasklfjas flkajflaskjfaslkfjas aslkfjasklf jsaklfj salkfja fklsajf salkfj fklasjf <div class="foo bar baz "><a href="#">Log Out</a></div>alksjf aisf a8f asjfiosajfiosajfsioafjsafjsaoijf soifja oifjs fioasj fasjoifs jaiofjsa iofajs fiosajf iosajf ioasjf saiojf aoisjfsao',
      '<div ><a href="foo">bar</a></di<div class=" "><a <div ><a href=""></div><div class="foo "><'
    ],
  '(0|1){10,20}(0|1|2){5,10}(0|1|2|3){3,5}(0|1|2|3|4){2,4}(0|1|2|3|4|5){0,3}' =>
    %w[
      0000000000111111111100000111100
      00000000000000000000000000000006
      000000000000000000001111111111222223333444
    ]
}

for str, tests in regexps
  puts str[0,30]
  native, c, rb = benchmark(/#{str}/, tests)
  

  puts "\tC-ext Regu: %f x native" % [native / c]
  puts "\tRuby Regu: %f x native"  % [native / rb]
  puts
end


