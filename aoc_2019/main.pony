
use "ponytest"
use "day_01"
use "day_02"
use "day_03"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(Day01Step01("../data/day_01.txt"))
    test(Day01Step02("../data/day_01.txt"))
    test(Day02Step01("../data/day_02.txt"))
    test(Day02Step02("../data/day_02.txt"))
    test(Day03Step01("../data/day_03.txt"))
    test(Day03Step02("../data/day_03.txt"))
