
use "collections"
use "itertools"
use "ponytest"
use "../utils"

class iso Day03Step02 is UnitTest
  let _fname: String

  new iso create(fname: String) =>
    _fname = fname

  fun name(): String => "Day_03_Step_02"

  fun apply(h: TestHelper) =>
    let example1 = get_least_delay(h, [
      "R8,U5,L5,D3"; "U7,R6,D4,L4"
    ])
    h.assert_eq[U64](30, example1)

    let example2 = get_least_delay(h, [
      "R75,D30,R83,U83,L12,D49,R71,U7,L72"
      "U62,R66,U55,R34,D71,R55,D58,R83"
    ])
    h.assert_eq[U64](610, example2)

    let example3 = get_least_delay(h, [
      "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"
      "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    ])
    h.assert_eq[U64](410, example3)

    let initial = Array[String]
    let lines = ProcessLines[Array[String]](h, _fname, initial, {(_, acc, line) =>
      acc.push(line.clone())
      (consume acc, true)
    })
    let distance = get_least_delay(h, lines)

    let expected: U64 = 25676
    h.env.out.print(name() + ": " + expected.string())
    h.assert_eq[U64](expected, distance)

  fun get_least_delay(h: TestHelper, lines: Array[String val]): U64 =>
    let grid = Map[I64, Map[I64, U64]]
    let steps = Map[I64, Map[I64, Array[U64]]]
    try
      // draw lines into grid
      var line_num: U64 = 0
      for line in lines.values() do
        var step: U64 = 1
        var x: I64 = 0
        var y: I64 = 0

        let tokens = line.split(",")
        for token in (consume tokens).values() do
          match token(0)?
          | 'U' =>
            let dy = token.trim(1).i64()?
            for y' in Range[I64](y + 1, y + dy + 1) do
              add_bit(grid, x, y', 1 << line_num)?
              add_step(steps, x, y', line_num, step)?
              step = step + 1
            end
            y = y + dy
          | 'D' =>
            let dy = token.trim(1).i64()?
            for y' in Range[I64](y - 1, y - dy - 1, -1) do
              add_bit(grid, x, y', 1 << line_num)?
              add_step(steps, x, y', line_num, step)?
              step = step + 1
            end
            y = y - dy
          | 'R' =>
            let dx = token.trim(1).i64()?
            for x' in Range[I64](x + 1, x + dx + 1) do
              add_bit(grid, x', y, 1 << line_num)?
              add_step(steps, x', y, line_num, step)?
              step = step + 1
            end
            x = x + dx
          | 'L' =>
            let dx = token.trim(1).i64()?
            for x' in Range[I64](x - 1, x - dx - 1, -1) do
              add_bit(grid, x', y, 1 << line_num)?
              add_step(steps, x', y, line_num, step)?
              step = step + 1
            end
            x = x - dx
          end
        end

        line_num = line_num + 1
      end

      // get closest intersection
      var least_delay = U64.max_value()
      for (x, col) in grid.pairs() do
        for (y, m) in col.pairs() do
          if m.popcount() == lines.size().u64() then
            let delay = Iter[U64](steps(x)?(y)?.values()).fold[U64](0, {(sum, n) => sum + n })
            if delay < least_delay then
              least_delay = delay
            end
          end
        end
      end
      least_delay
    else
      h.fail("Error")
      U64.max_value()
    end

  fun add_bit(grid: Map[I64, Map[I64, U64]], x: I64, y: I64, bit: U64) ?
  =>
    let col =
      if not grid.contains(x) then
        grid.insert(x, Map[I64, U64])
      else
        grid(x)?
      end
    col.upsert(y, bit, {(prev, next) => prev or next })

  fun add_step(steps: Map[I64, Map[I64, Array[U64]]], x: I64, y: I64,
    line_num: U64, step: U64) ?
  =>
    let col =
      if not steps.contains(x) then
        steps.insert(x, Map[I64, Array[U64]])
      else
        steps(x)?
      end

    let delays =
      if not col.contains(y) then
        col.insert(y, Array[U64])
      else
        col(y)?
      end

    let ln = line_num.usize()
    while delays.size() < (ln + 1) do
      delays.push(0)
    end

    if delays(ln)? == 0 then
      delays(ln)? = step
    end
