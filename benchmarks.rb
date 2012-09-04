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
  '[abcdef]{2,3}b*[abcdef]{2,3}[abcdef]{2,3}b{2,3}[abcdef]*[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}' =>
    %w[
      aaabbaaabbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
      a
      b
      aabbbaaabbb
      aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
      aabbaabbaabbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
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
