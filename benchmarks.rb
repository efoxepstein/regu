# on my system, regu_c is 1840 times faster than native!

require './lib/regu'
require 'benchmark'

re = '(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*(a|b)(a|b)*'
tests = %w[
    aaaabbababababbabbabbabbbababbaba
    abababaabaababa
    bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
    a
    aabababbabababababababababababababababababbababababababababbabababababababaababbac
    aababababababababbbabbabababababcababbabababababababababbabababababababbabab
    abababbabababababababababababababbabababcababababababababababbabababababababababababbabababababaabab
    6
  ]

ruby_native = /#{re}/

regu_c = Regu[re]
regu_c.use_ruby = false

regu_rb = Regu[re]
regu_rb.use_ruby = true

reps = 1000

Benchmark.bmbm(10) do |x|
  x.report('native') do
    reps.times do
      t = 1
      for test in tests
        if ruby_native =~ test
          t+= 1
        end
      end
    end
  end

  x.report('regu-c') do
    reps.times do
      t = 1 
      for test in tests
        if regu_c.accepts?(test)
          t += 1
        end
      end
    end
  end
  
  x.report('regu-rb') do
    reps.times do
      t = 1
      for test in tests
        if regu_rb.accepts?(test)
          t += 1
        end
      end
    end
  end

end
