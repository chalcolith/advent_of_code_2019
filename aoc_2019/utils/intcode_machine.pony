
use "ponytest"

class IntcodeMachine
  let memory: Array[I64]

  let _instruction_lengths: Array[USize] = [
    USize.max_value()
    4
    4
  ]

  new create(memory': Array[I64]) =>
    memory = memory'

  fun ref run(start_index: USize = 0): (String | None) =>
    var index: USize = start_index
    while index < memory.size() do
      try
        let opcode = memory(index)?
        if opcode == 99 then
          return
        end

        let addr_a = memory(index + 1)?.usize()
        let addr_b = memory(index + 2)?.usize()
        let addr_dest = memory(index + 3)?.usize()

        match opcode
        | 1 =>
          memory(addr_dest)? = memory(addr_a)? + memory(addr_b)?
        | 2 =>
          memory(addr_dest)? = memory(addr_a)? * memory(addr_b)?
        else
          return "Unknown opcode " + opcode.string() + " at index " + index.string()
        end
        index = index + _instruction_lengths(opcode.usize())?
      else
        return "Buffer overrun at index " + index.string()
      end
    end
    None
