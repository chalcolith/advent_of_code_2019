
use "collections"
use "ponytest"

class IntcodeMachine
  let memory: Array[I64]
  let output: Array[I64]

  let _input: Iterator[I64]
  let _immediate_flags: Array[Bool] = _immediate_flags.init(false, 4)

  let _instruction_lengths: Array[USize] = [
    USize.max_value()
    4 // 1
    4
    2
    2
    3 // 5
    3
    4
    4
  ]

  new create(memory': Array[I64], input': Iterator[I64], output': Array[I64]) =>
    memory = memory'
    _input = input'
    output = output'

  fun ref run(start_index: USize = 0): (String | None) =>
    var index: USize = start_index
    while index < memory.size() do
      try
        _clear_immediate_flags()?
        var ip_modified = false

        let opcode = _decode_instruction(memory(index)?)?
        if opcode == 99 then return end

        // execute
        match opcode
        | 1 =>
          let a = _get_rvalue(0, memory(index + 1)?)?
          let b = _get_rvalue(1, memory(index + 2)?)?
          let d = memory(index + 3)?.usize()
          memory(d)? = a + b

        | 2 =>
          let a = _get_rvalue(0, memory(index + 1)?)?
          let b = _get_rvalue(1, memory(index + 2)?)?
          let d = memory(index + 3)?.usize()
          memory(d)? = a * b

        | 3 =>
          if _input.has_next() then
            let d = memory(index + 1)?.usize()
            memory(d)? = _input.next()?
          else
            return "Input underflow at index " + index.string()
          end

        | 4 =>
          let a = _get_rvalue(0, memory(index + 1)?)?
          output.push(a)

        | 5 =>
          let a = _get_rvalue(0, memory(index + 1)?)?
          if a != 0 then
            index = _get_rvalue(1, memory(index + 2)?)?.usize()
            ip_modified = true
          end

        | 6 =>
          let a = _get_rvalue(0, memory(index + 1)?)?
          if a == 0 then
            index = _get_rvalue(1, memory(index + 2)?)?.usize()
            ip_modified = true
          end

        | 7 =>
          let a = _get_rvalue(0, memory(index + 1)?)?
          let b = _get_rvalue(1, memory(index + 2)?)?
          let d = memory(index+3)?.usize()
          memory(d)? = if a < b then 1 else 0 end

        | 8 =>
          let a = _get_rvalue(0, memory(index + 1)?)?
          let b = _get_rvalue(1, memory(index + 2)?)?
          let d = memory(index+3)?.usize()
          memory(d)? = if a == b then 1 else 0 end

        else
          return "Unknown opcode " + opcode.string() + " at index " + index.string()
        end

        if not ip_modified then
          index = index + _instruction_lengths(opcode.usize())?
        end
      else
        return "Buffer overrun at index " + index.string()
      end
    end
    None

  fun ref _clear_immediate_flags() ? =>
    for i in Range[USize](0, _immediate_flags.size()) do
      _immediate_flags(i)? = false
    end

  fun ref _decode_instruction(inst: I64): I64 ? =>
    var instruction = inst
    let opcode = instruction % 100

    instruction = instruction / 100
    var i: USize = 0
    while instruction > 0 do
      while _immediate_flags.size() < (i+1) do
        _immediate_flags.push(false)
      end

      let flag = instruction % 10
      _immediate_flags(i)? = flag != 0
      instruction = instruction / 10
      i = i + 1
    end
    opcode

  fun ref _get_rvalue(param: USize, index: I64): I64 ? =>
    if _immediate_flags(param)? then
      index
    else
      memory(index.usize())?
    end
