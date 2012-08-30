#include <ruby.h>
#include <table.c>

static VALUE regu_new(VALUE class, VALUE re) {
  VALUE argv[1] = { re };

  // 1. compile
  regu *unboxed_regu = ALLOC(regu);

  int i;
  VALUE *ptr = RARRAY_PTR(re);
  for (i = 0; i < RARRAY_LEN(re); ++i) {
    VALUE *ptr2 = RARRAY_PTR(ptr[i]);
    AddTransition(*unboxed_regu, NUM2INT(ptr2[0]), NUM2INT(ptr2[1]), NUM2INT(ptr2[2]));
  }
  
  // 2. store
  VALUE boxed_regu = Data_Wrap_Struct(class, 0, free, unboxed_regu);
  
  // 3. make Ruby object
  rb_obj_call_init(boxed_regu, 1, argv);
  return boxed_regu;
}

static VALUE regu_init(VALUE self, VALUE re) {
  rb_iv_set(self, "@re", re);
  return self;
}

static VALUE regu_test(VALUE self, VALUE str) {
}

void Init_regu(void) {
  VALUE regu = rb_define_module("Regu");
  VALUE klass = rb_define_class_under(regu, "FA");
  
  rb_define_singleton_method(klass, "new", regu_new, 1);
  rb_define_method(klass, "initialize", regu_init, 1);
  rb_define_method(klass, "test", regu_test, 1);
}


