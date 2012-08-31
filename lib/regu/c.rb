require 'inline'

module Regu
  class Table
    inline do |builder|
      builder.include '<stdbool.h>'
      
      builder.add_compile_flags '-std=c99'
      
      builder.c <<-END_C
        bool accepts(char **table, char *word, int len) {
          char state = 0;

          for (int i = 0; i < len; ++i)
            state = table[(int)state][(int)word[i]];

          return table[state][128] != 0;
        }
      END_C
      
      alias_method :accepts?, :accepts
    end
  end
end