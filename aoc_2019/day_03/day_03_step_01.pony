
use "collections"
use "ponytest"
use "../utils"

class iso Day03Step01 is UnitTest
  let _fname: String

  new iso create(fname: String) =>
    _fname = fname

  fun name(): String => "Day_03_Step_01"

  fun apply(h: TestHelper) =>
    let example1 = get_least_distance(h, [
      "R8,U5,L5,D3"; "U7,R6,D4,L4"
    ])
    h.assert_eq[I64](6, example1)

    let example2 = get_least_distance(h, [
      "R75,D30,R83,U83,L12,D49,R71,U7,L72"
      "U62,R66,U55,R34,D71,R55,D58,R83"
    ])
    h.assert_eq[I64](159, example2)

    let example3 = get_least_distance(h, [
      "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"
      "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    ])
    h.assert_eq[I64](135, example3)

    let initial = Array[String]
    let lines = ProcessLines[Array[String]](h, _fname, initial, {(_, acc, line) =>
      acc.push(line.clone())
      (consume acc, true)
    })
    let distance = get_least_distance(h, lines)

    let expected: I64 = 1064
    h.env.out.print(name() + ": " + expected.string())
    h.assert_eq[I64](expected, distance)

  fun get_least_distance(h: TestHelper, lines: Array[String val]): I64 =>
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
            let dy = token.trim(1).i64()?
            for y' in Range[I64](y + 1, y + dy + 1) do
              add_bit(grid, x, y', bit)?
            end
            y = y + dy
          | 'D' =>
            let dy = token.trim(1).i64()?
            for y' in Range[I64](y - 1, y - dy - 1, -1) do
              add_bit(grid, x, y', bit)?
            end
            y = y - dy
          | 'R' =>
            let dx = token.trim(1).i64()?
            for x' in Range[I64](x + 1, x + dx + 1) do
              add_bit(grid, x', y, bit)?
            end
            x = x + dx
          | 'L' =>
            let dx = token.trim(1).i64()?
            for x' in Range[I64](x - 1, x - dx - 1, -1) do
              add_bit(grid, x', y, bit)?
            end
            x = x - dx
          end
        end

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

  fun add_bit(grid: Map[I64, Map[I64, U64]], x: I64, y: I64, bit: U64) ? =>
    let col =
      if not grid.contains(x) then
        grid.insert(x, Map[I64, U64])
      else
        grid(x)?
      end
    col.upsert(y, bit, {(prev, next) => prev or next })
