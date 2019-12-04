
use "ponytest"
use "../utils"

class iso Day01Step02 is UnitTest
  let _fname: String

  new iso create(fname: String) =>
    _fname = fname

  fun name(): String => "Day_01_Step_02"

  fun apply(h: TestHelper) =>
    let self: Day01Step02 box = this

    let total_fuel = ProcessLinesI64[I64](h, _fname, 0, {(_, fuel, mass) =>
      let f = self.get_fuel(mass)
      (fuel + f, true)
    })

    h.assert_eq[I64](4856390, total_fuel)

  fun get_fuel(mass: I64): I64 =>
    if mass > 0 then
      let fuel = (mass / 3) - 2
      if fuel > 0 then
        return fuel + get_fuel(fuel)
      end
    end
    0
