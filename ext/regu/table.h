#include <stdlib.h>
#include <stdbool.h>

typedef char sym;

typedef sym **table;

typedef struct {
  table tab;
  sym numStates;
} regu;

regu CreateTable(sym numStates) {
  regu reg;
  table tab = (table) malloc(numStates * sizeof(numStates));
  
  for (int i = 0; i < numStates; ++i)
    tab[i] = (sym *) calloc(129, sizeof(numStates));

  reg.tab = tab;
  reg.numStates = numStates;

  return reg;
}

void AddTransition(regu reg, sym src, sym on, sym dst) {
  reg.tab[(int) src][(int) on] = dst;
}

void MakeAcceptState(regu reg, sym state) {
  reg.tab[(int) state][128] = 1;
}

bool Accepts(regu reg, sym *word, int len) {
  table tab = reg.tab;
  sym state = 0;

  for (int i = 0; i < len; ++i)
    state = tab[(int) state][(int) word[i]];

  return tab[(int) state][128] == 1;
}
