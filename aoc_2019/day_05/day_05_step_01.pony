
use "ponytest"
use "../utils"

class iso Day05Step01 is UnitTest
  let _fname: String

  new iso create(fname: String) =>
    _fname = fname

  fun name(): String => "Day_05_Step_01"

  fun apply(h: TestHelper) =>
    try
      let example1 = [ as I64: 1002; 4; 3; 4; 33 ]
      let input1 = Array[I64]
      let output1 = Array[I64]

      run_program(h, example1, input1.values(), output1)
      h.assert_eq[I64](99, example1(4)?)

      let memory = ProcessNums(h, _fname)
      let input = [ as I64: 1 ]
      let output = Array[I64]
      run_program(h, memory, input.values(), output)
      let diagnostic = output.pop()?
      for o in output.values() do
        h.assert_eq[I64](0, o)
      end

      let expected: I64 = 16489636
      h.env.out.print(name() + ": " + expected.string())
      h.assert_eq[I64](expected, diagnostic)
    else
      h.fail()
    end

  fun run_program(h: TestHelper, memory: Array[I64], input: Iterator[I64], output: Array[I64]) =>
    let machine = IntcodeMachine(memory, input, output)
    match machine.run()
    | let err: String => h.fail(err)
    end
