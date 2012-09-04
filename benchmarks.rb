require './lib/regu'
require 'benchmark'

tests = {
  '(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*' =>
    %w[
      aaaabbababababbabbabbabbbababbaba
      abababaabaababa
      bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
      a
      aabababbabababababababababababababababababbababababababababbabababababababaababbac
      aababababababababbbabbabababababcababbabababababababababbabababababababbabab
      abababbabababababababababababababbabababcababababababababababbabababababababababababbabababababaabab
      6
      cbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
    ],
  '[abcdef]{2,3}b[abcdef]{2,3}[abcdef]{2,3}b{2,3}[abcdef]*[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}[abcdef]{2,3}' =>
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
  regu = ruby_native.regu
  
  [[ruby_native, regu], test_cases]
end

reps = 500

a, b, c = 0, 0, 0

results = Benchmark.bmbm(7) do |x|
  x.report('native') do
    reps.times do
      regexps.each do |regs, tests|
        for test in tests
          a += 1 if regs[0] =~ test
        end
      end
    end
  end

  x.report('regu-c') do
    reps.times do
      regexps.each do |regs, tests|
        regs[1].use_ruby = false
        for test in tests
          b += 1 if regs[1] =~ test
        end
      end
    end
  end
  x.report('regu-rb') do
    reps.times do
      regexps.each do |regs, tests|
        regs[1].use_ruby = true
        for test in tests
          c += 1 if regs[1] =~ test
        end
      end
    end
  end
end

raise 'Successes not matching' unless a == b && b == c

puts "\n"

puts "C-ext Regu is %f times faster than native" % [results[0].real / results[1].real]
puts " Ruby Regu is %f times faster than native" % [results[0].real / results[2].real]
