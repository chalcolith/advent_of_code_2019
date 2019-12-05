
use "files"
use "ponytest"

primitive ProcessNums
  fun apply(h: TestHelper, fname: String): Array[I64] =>
    let arr = Array[I64]
    try
      let path = FilePath(h.env.root as AmbientAuth, fname)?

      match OpenFile(path)
      | let file: File =>
        var num: ISize = 0
        let lines = FileLines(file)
        for line in lines do
          for token in line.split(",").values() do
            try
              let n = token.i64()?
              arr.push(n)
            else
              h.fail("Unable to parse I64 '" + token + "' in line " + num.string())
            end
          end
          num = num + 1
        end
      else
        h.fail("Unable to open file: " + fname)
      end
    else
      h.fail("Unable to get file path: " + fname)
    end
    arr
