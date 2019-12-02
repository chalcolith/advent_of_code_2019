
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
        let lines = FileLines(file)
        var num: ISize = 1
        for line in lines do
          (cur, let go_on) = proc(num, cur, consume line)
          if not go_on then
            return cur
          end
        end
        file.dispose()
      else
        h.fail("Unable to open file: " + fname)
      end
    else
      h.fail("Unable to get file path: " + fname)
    end
    cur
