
use "collections"
use "ponytest"
use "../utils"

class iso Day03Step01 is UnitTest
  let _fname: String

  new iso create(fname: String) =>
    _fname = fname

  fun name(): String => "Day_03_Step_01"

  fun apply(h: TestHelper) =>
    let example1 = get_distance(h, [ "R8,U5,L5,D3"; "U7,R6,D4,L4" ])
    h.assert_eq[I64](6, example1)

  fun get_distance(h: TestHelper, lines: Array[String]): I64 =>
    let grid = Map[I64, Map[I64, U64]]
    try
      // draw lines into grid
      var bit: U64 = 1
      for line in lines.values() do
        var x: I64 = 0
        var y: I64 = 0

        let tokens = line.split(",")
        for token in (consume tokens).values() do
          match token(0)?
          | 'U' =>
            y = y + token.trim(1).i64()?
          | 'D' =>
            y = y - token.trim(1).i64()?
          | 'R' =>
            x = x + token.trim(1).i64()?
          | 'L' =>
            x = x - token.trim(1).i64()?
          end
        end

        let col =
          if not grid.contains(x) then
            grid.insert(x, Map[I64, U64])
          else
            grid(x)?
          end

        col.upsert(y, bit, {(prev, next) => prev or next })

        bit = bit << 1
      end

      // get closest intersection
      var least_distance = I64.max_value()
      for (x, col) in grid.pairs() do
        for (y, m) in col.pairs() do
          if m.popcount() == lines.size().u64() then
            let distance = x.abs().i64() + y.abs().i64()
            if distance < least_distance then
              least_distance = distance
            end
          end
        end
      end

      least_distance
    else
      h.fail("Error")
      I64.max_value()
    end
