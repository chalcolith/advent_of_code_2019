
use "files"
use "ponytest"

primitive ProcessLines[T: Any #share]
  fun apply(h: TestHelper, fname: String, initial: T,
    proc: {(ISize, T, String iso): (T, Bool)}) : T
  =>
    var cur = initial
    try
      let path = FilePath(h.env.root as AmbientAuth, fname)?

      match OpenFile(path)
      | let file: File =>
        var num: ISize = 1
        let lines = FileLines(file)
        for line in lines do
          (cur, let go_on) = proc(num, cur, consume line)
          if not go_on then
            return cur
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
    cur

primitive ProcessLinesI64[T: Any #share]
  fun apply(h: TestHelper, fname: String, initial: T,
    proc: {(ISize, T, I64): (T, Bool)}) : T
  =>
    ProcessLines[T](h, fname, initial, {(num, acc, line) =>
      if line.size() > 0 then
        line.lstrip("+")
        try
          let n = line.i64()?
          return proc(num, acc, n)
        else
          h.fail("Could not parse I64: '" + line.string() + "' at line "
            + num.string())
        end
      else
        h.fail("Empty line " + num.string())
      end
      (acc, false)
    })
