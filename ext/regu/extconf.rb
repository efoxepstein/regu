require 'mkmf'

$CFLAGS += ' -std=c99 -Wall -Wextra'

create_makefile 'regu/regu'