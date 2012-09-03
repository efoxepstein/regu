require './lib/regu'
require 'benchmark'

regexps = {
  '(a|b)(a|b)*(a|b)(a|b)*' => %w[
    aaaabbababababbabbabbabbbababbaba
    abababaabaababa
    bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
    a
    aabababbabababababababababababababababababbababababababababbabababababababaababbac
    aababababababababbbabbabababababcababbabababababababababbabababababababbabab
  ]
}

reps = 100

Benchmark.bmbm(10) do |x|
  x.report('native') do
    reps.times do
      t = 0
      for re, tests in regexps
        rex = /#{re}/
        for test in tests
          if rex =~ test
            t+= 1
          end
        end
      end
    end
  end

  x.report('regu-c') do
    reps.times do
      t =0 
      for re, tests in regexps
        rex = Regu[re]
        rex.use_ruby = false
        for test in tests
          if rex.accepts?(test)
            t += 1
          end
        end
      end
    end
  end
  
  x.report('regu-rb') do
    reps.times do
      t = 0
      for re, tests in regexps
        rex = Regu[re]
        rex.use_ruby = true
        for test in tests
          if rex.accepts?(test)
            t += 1
          end
        end
      end
    end
  end
end
