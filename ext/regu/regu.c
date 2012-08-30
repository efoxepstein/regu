#include <ruby.h>
#include <table.c>

static VALUE regu_new(VALUE class) {
  // 1. compile
  regu *unboxed_regu = ALLOC(regu);

  // 2. store
  VALUE boxed_regu = Data_Wrap_Struct(class, 0, free, unboxed_regu);

  return boxed_regu;
}

static regu *get_regu(VALUE self) {
  regu *unboxed_regu;
  Data_Get_Struct(self, regu, unboxed_regu);
  return unboxed_regu;
}

static VALUE regu_add_transition(VALUE self, VALUE from, VALUE on, VALUE to) {
  regu *unboxed_regu = get_regu(self);
  
  AddTransition(*unboxed_regu,
    NUM2CHR(from),
    NUM2CHR(on),
    NUM2CHR(to));
  
  return self;
}

static VALUE regu_make_accepting(VALUE self, VALUE state) {
  regu *re = get_regu(self);
  MakeAcceptState(*re, NUM2CHR(state));
  return self;
}

static VALUE regu_test(VALUE self, VALUE str) {
  regu *re = get_regu(self);
  
  return Accepts(*re, RSTRING_PTR(str), RSTRING_LEN(str)) ? Qtrue : Qfalse;
}


void Init_regu(void) {
  VALUE regu = rb_define_module("Regu");
  VALUE klass = rb_define_class_under(regu, "FA", rb_cObject);
  
  rb_define_singleton_method(klass, "new", regu_new, 1);
  rb_define_method(klass, "add_transition", regu_add_transition, 3);
  rb_define_method(klass, "make_accepting", regu_make_accepting, 1);
  rb_define_method(klass, "test", regu_test, 1);
  
}


