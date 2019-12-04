
use "ponytest"
use "../utils"

class iso Day01Step01 is UnitTest
  let _fname: String

  new iso create(fname: String) =>
    _fname = fname

  fun name(): String => "Day_01_Step_01"

  fun apply(h: TestHelper) =>
    let total_fuel = ProcessLinesI64[I64](h, _fname, 0, {(_, fuel, mass) =>
      let f = (mass / 3) - 2
      if f >= 0 then
        (fuel + f, true)
      else
        (fuel, true)
      end
    })

    h.assert_eq[I64](3239503, total_fuel)
