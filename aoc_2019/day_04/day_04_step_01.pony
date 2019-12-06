
use "collections"
use "itertools"
use "ponytest"

class iso Day04Step01 is UnitTest
  fun name(): String => "Day_04_Step_01"

  fun apply(h: TestHelper) =>
    h.assert_eq[Bool](true, PasswdValid(122345))
    h.assert_eq[Bool](true, PasswdValid(111123))
    h.assert_eq[Bool](true, PasswdValid(111111))
    h.assert_eq[Bool](false, PasswdValid(223450))
    h.assert_eq[Bool](false, PasswdValid(123789))
    h.assert_eq[Bool](false, PasswdValid(123))
    h.assert_eq[Bool](false, PasswdValid(1234567))

    let range = Range[USize](236491, 713787 + 1)
    let num_valid = Iter[USize](range).fold[USize](0, {(total, n) =>
      if PasswdValid(n) then total + 1 else total end
    })

    let expected: USize = 1169
    h.env.out.print(name() + ": " + expected.string())
    h.assert_eq[USize](expected, num_valid)

primitive PasswdValid
  fun apply(n: USize) : Bool =>
    var str: String box = n.string()
    if str.codepoints() == 6 then
      var num_dups: USize = 0

      var last: U32 = 0
      for ch in str.runes() do
        if ch == last then num_dups = num_dups + 1 end
        if ch < last then return false end
        last = ch
      end
      num_dups > 0
    else
      false
    end
