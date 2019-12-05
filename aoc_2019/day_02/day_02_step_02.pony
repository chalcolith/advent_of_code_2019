
use "collections"
use "ponytest"
use "../utils"

class iso Day02Step02 is UnitTest
  let _fname: String

  new iso create(fname: String) =>
    _fname = fname

  fun name(): String => "Day_02_Step_02"

  fun apply(h: TestHelper) =>
    let core = ProcessNums(h, _fname)
    try
      (let noun, let verb) = find_noun_verb(h, core)?
      let word = (noun * 100) + verb

      let expected: I64 = 3951
      h.env.out.print(name() + ": " + expected.string())
      h.assert_eq[I64](expected, word)
    else
      h.fail("Did not find noun and verb.")
    end

  fun find_noun_verb(h: TestHelper, core: Array[I64]): (I64, I64)? =>
    for noun in Range[I64](0, 100) do
      for verb in Range[I64](0, 100) do
        var machine = IntcodeMachine(core.clone())
        machine.memory(1)? = noun
        machine.memory(2)? = verb
        match machine.run()
        | let err: String =>
          h.fail(err)
          error
        end
        if machine.memory(0)? == 19690720 then
          return (noun, verb)
        end
      end
    end
    error
