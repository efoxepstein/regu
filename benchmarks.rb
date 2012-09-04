# on my system, regu_c is 1840 times faster than native!

require './lib/regu'
require 'benchmark'

tests = {
  '(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*' =>
    %w[
      aaaabbababababbabbabbabbbababbaba
      abababaabaababa
      bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
      a
      aabababbabababababababababababababababababbababababababababbabababababababaababbac
      aababababababababbbabbabababababcababbabababababababababbabababababababbabab
      abababbabababababababababababababbabababcababababababababababbabababababababababababbabababababaabab
      6
    ],
  'a{2,3}b{2,3}a{2,3}b{2,3}a{2,3}b{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}a{2,3}' =>
    %w[
      aaabbaaabbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
      a
      b
      aabbbaaabbb
      aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
      aabbaabbaabbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    ],
  'zygous|zygozoospore|zymase|zyme|zymic|zymin|zymite|zymogen|zymogene|zymogenesis|zymogenic|zymogenous|zymoid|zymologic|zymological|zymologist|zymology|zymolyis|zymolysis|zymolytic|zymome|zymometer|zymomin|zymophore|zymophoric|zymophosphate|zymophyte|zymoplastic|zymoscope|zymosimeter|zymosis|zymosterol|zymosthenic|zymotechnic|zymotechnical|zymotechnics|zymotechny|zymotic|zymotically|zymotize|zymotoxic|zymurgy|Zyrenian|Zyrian|Zyryan|zythem|Zythia|zythum|Zyzomys|Zyzzogeton' =>
    %w[
      zymester
      zymogene
      z
      zealot
      zymological
      Zygozoospore
    ]
}


regexps = tests.to_a.map do |re, test_cases|
  ruby_native = /#{re}/

  regu_c = ruby_native.regu
  regu_c.use_ruby = false

  regu_rb = ruby_native.regu
  regu_rb.use_ruby = true
  
  [[ruby_native, regu_c, regu_rb], test_cases]
end

reps = 1000

results = Benchmark.bmbm(7) do |x|
  x.report('native') do
    t = 1
    reps.times do
      regexps.each do |regs, tests|
        for test in tests
          t += 1 if regs[0] =~ test
        end
      end
    end
  end

  x.report('regu-c') do
    t = 1
    reps.times do
      regexps.each do |regs, tests|
        for test in tests
          t += 1 if regs[1] =~ test
        end
      end
    end
  end
  
  x.report('regu-rb') do
    t = 1
    reps.times do
      regexps.each do |regs, tests|
        for test in tests
          t += 1 if regs[2] =~ test
        end
      end
    end
  end
end

puts "\n"

puts "C-ext Regu is %f times faster than native"  % [results[0].real / results[1].real]
puts " Ruby Regu is %f times faster than native" % [results[0].real / results[2].real]
