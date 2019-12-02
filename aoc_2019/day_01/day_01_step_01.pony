
use "ponytest"
use "../utils"

class iso Day01Step01 is UnitTest
  let _fname: String

  new iso create(input_fname: String) =>
    _fname = input_fname

  fun name(): String => "Day_01_Step_01"

  fun apply(h: TestHelper) =>
    let self: Day01Step01 box = this
    let mass = ProcessLines[I64](h, _fname, 0, self~process(h))
    h.assert_eq[I64](-123, mass)

  fun process(h: TestHelper, num: ISize, acc: I64, line: String iso)
    : (I64, Bool)
  =>
    if line.size() > 0 then
      line.lstrip("+")
      try
        let n = line.i64()?
        let m = (n / 3) - 2
        (acc + m, true)
      else
        h.fail("Could not parse I64: '" + (consume line) + "' in line " +
          num.string())
      end
    end
    h.fail("Empty line " + num.string())
    (acc, false)
