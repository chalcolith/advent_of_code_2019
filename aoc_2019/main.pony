
use "ponytest"
use "day_01"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(Day01Step01("../data/day_01.txt"))
