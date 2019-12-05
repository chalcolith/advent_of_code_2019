
use "ponytest"
use "../utils"

class iso Day02Step01 is UnitTest
  let _fname: String

  new iso create(fname: String) =>
    _fname = fname

  fun name(): String => "Day_02_Step_01"

  fun apply(h: TestHelper) =>
    try
      let example1: Array[I64] = [ 1; 0; 0; 0; 99 ]
      run_core(h, example1)
      h.assert_eq[I64](2, example1(0)?)

      let example2: Array[I64] = [ 2; 3; 0; 3; 99 ]
      run_core(h, example2)
      h.assert_eq[I64](6, example2(3)?)

      let example3: Array[I64] = [ 2; 4; 4; 5; 99; 0 ]
      run_core(h, example3)
      h.assert_eq[I64](9801, example3(5)?)

      let example4: Array[I64] = [ 1; 1; 1; 4; 99; 5; 6; 0; 99 ]
      run_core(h, example4)
      h.assert_eq[I64](30, example4(0)?)
      h.assert_eq[I64](2, example4(4)?)

      let core = ProcessNums(h, _fname)
      core(1)? = 12
      core(2)? = 2
      run_core(h, core)

      let expected: I64 = 6568671
      h.env.out.print(name() + ": " + expected.string())
      h.assert_eq[I64](expected, core(0)?)
    else
      h.fail("Buffer overrun in tests")
    end

  fun run_core(h: TestHelper, core: Array[I64]) =>
    let machine = IntcodeMachine(core)
    match machine.run()
    | let err: String => h.fail(err)
    end
