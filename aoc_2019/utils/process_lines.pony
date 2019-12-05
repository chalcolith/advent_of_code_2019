
use "files"
use "ponytest"

primitive ProcessLines[T]
  fun apply(h: TestHelper, fname: String, initial: T^,
    proc: {(ISize, T, String iso): (T^, Bool)}) : T^
  =>
    var cur = initial
    try
      let path = FilePath(h.env.root as AmbientAuth, fname)?

      match OpenFile(path)
      | let file: File =>
        var num: ISize = 1
        let lines = FileLines(file)
        for line in lines do
          (cur, let go_on) = proc(num, consume cur, consume line)
          if not go_on then
            return consume cur
          end
          num = num + 1
        end
        file.dispose()
      else
        h.fail("Unable to open file: " + fname)
      end
    else
      h.fail("Unable to get file path: " + fname)
    end
    consume cur

primitive ProcessLinesI64[T]
  fun apply(h: TestHelper, fname: String, initial: T^,
    proc: {(ISize, T, I64): (T^, Bool)}) : T^
  =>
    var cur = initial
    try
      let path = FilePath(h.env.root as AmbientAuth, fname)?

      match OpenFile(path)
      | let file: File =>
        var num: ISize = 1
        let lines = FileLines(file)
        for line in lines do
          line.lstrip("+")
          match try line.i64()? end
          | let n: I64 =>
            (cur, let go_on) = proc(num, consume cur, n)
            if not go_on then return consume cur end
          else
            h.fail("Unable to parse I64 " + line.string())
            return consume cur
          end
          num = num + 1
        end
        file.dispose()
      else
        h.fail("Unable to open file: " + fname)
      end
    else
      h.fail("Unable to get file path: " + fname)
    end
    consume cur

// Why won't this work?
// Why does the `consume initial` return `T #any` and not `T #any^`?

// primitive ProcessLinesI64[T]
//   fun apply(h: TestHelper, fname: String, initial: T^,
//     proc: {(ISize, T, I64): (T^, Bool)}) : T^
//   =>
//     ProcessLines[T](h, fname, consume initial, {(num, acc, line) =>
//       if line.size() > 0 then
//         line.lstrip("+")
//         match try line.i64()? end
//         | let n: I64 =>
//           return proc(num, consume acc, n)
//         else
//           h.fail("Could not parse I64: '" + line.string() + "' at line "
//             + num.string())
//         end
//       else
//         h.fail("Empty line " + num.string())
//       end
//       (consume acc, false)
//     })
