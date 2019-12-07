
use "ponytest"
use "../utils"

class iso Day05Step02 is UnitTest
  let _fname: String

  new iso create(fname: String) =>
    _fname = fname

  fun name(): String => "Day_05_Step_02"

  fun apply(h: TestHelper) =>
    try
      let example1 = [ as I64: 3;12;6;12;15;1;13;14;13;4;13;99;-1;0;1;9]

      let input1 = [ as I64: 123 ]
      let output1 = Array[I64]
      run_program(h, example1.clone(), input1.values(), output1)
      h.assert_eq[I64](1, output1.pop()?)

      let input2 = [ as I64: 0 ]
      let output2 = Array[I64]
      run_program(h, example1.clone(), input2.values(), output2)
      h.assert_eq[I64](0, output2.pop()?)

      let memory = ProcessNums(h, _fname)
      let input = [ as I64: 5 ]
      let output = Array[I64]
      run_program(h, memory, input.values(), output)
      let diagnostic = output.pop()?

      let expected: I64 = 9386583
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
