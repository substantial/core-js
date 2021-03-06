{module, test} = QUnit
module \ES6

{getPrototypeOf} = core.Object

test 'Reflect.construct' (assert)->
  {construct} = core.Reflect
  assert.isFunction construct
  assert.arity construct, 2
  if \name of construct
    assert.name construct, \construct
  C = (a, b, c)-> @qux = a + b + c
  assert.strictEqual construct(C, <[foo bar baz]>).qux, \foobarbaz, \basic
  C.apply = 42
  assert.strictEqual construct(C, <[foo bar baz]>).qux, \foobarbaz, 'works with redefined apply'
  inst = construct((-> @x = 42), [], Array)
  assert.strictEqual inst.x, 42, 'constructor with newTarget'
  assert.ok inst instanceof Array, 'prototype with newTarget' # still not work in native MS Edge and FF implementations
  assert.throws (-> construct 42, []), TypeError, 'throws on primitive'
  f = (->)
  f:: = 42
  assert.ok try getPrototypeOf(construct f, []) is Object::
  catch => no
  assert.strictEqual construct(core.Set, [[1, 2, 3, 2, 1]]).size, 3, 'works with native constructors'