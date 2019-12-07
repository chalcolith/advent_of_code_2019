
use "collections"
use "itertools"
use "ponytest"

class iso Day04Step02 is UnitTest
  fun name(): String => "Day_04_Step_02"

  fun apply(h: TestHelper) =>
    h.assert_eq[Bool](true, PasswdValid2(122345))
    h.assert_eq[Bool](true, PasswdValid2(112233))
    h.assert_eq[Bool](false, PasswdValid2(111123))
    h.assert_eq[Bool](false, PasswdValid2(111111))
    h.assert_eq[Bool](false, PasswdValid2(123444))
    h.assert_eq[Bool](true, PasswdValid2(111122))
    h.assert_eq[Bool](false, PasswdValid2(223450))
    h.assert_eq[Bool](false, PasswdValid2(123789))
    h.assert_eq[Bool](false, PasswdValid2(123))
    h.assert_eq[Bool](false, PasswdValid2(1234567))

    let range = Range[USize](236491, 713787 + 1)
    let num_valid = Iter[USize](range).fold[USize](0, {(total, n) =>
      if PasswdValid2(n) then total + 1 else total end
    })

    let expected: USize = 757
    h.env.out.print(name() + ": " + expected.string())
    h.assert_eq[USize](expected, num_valid)

primitive PasswdValid2
  fun apply(n: USize) : Bool =>
    var str: String box = n.string()
    if str.codepoints() == 6 then
      var num_dups: USize = 0

      var last: U32 = 0
      for ch in str.runes() do
        if ch < last then return false end
        last = ch
      end

      last = 0
      var streak: USize = 0
      var num_2s: USize = 0

      for ch in str.runes() do
        if ch == last then
          streak = streak + 1
          if streak == 2 then
            num_2s = num_2s - 1
          elseif streak == 1 then
            num_2s = num_2s + 1
          end
        else
          streak = 0
        end
        last = ch
      end
      num_2s > 0
    else
      false
    end
