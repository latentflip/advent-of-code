defmodule Day7 do
  def part1(instructions) do
    instructions
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
    |> List.foldl(%{}, &apply_instruction/2)
    |> IO.inspect
  end

  def apply_instruction(instruction, wires) do
    case instruction do
      {:assign, {:value, n}, target} -> Map.put(wires, target, n)
      _ -> wires
    end
  end

  def parse_instruction(instruction) do
    [op, target] = String.split(instruction, "->", trim: true)
    target = target |> String.trim |> String.to_atom

    case String.split(op, " ", trim: true) do
      [value]        -> {:assign, parse_value(value), target}
      ["NOT", value] -> {:not, parse_value(value), target}
      [a, op, b]     -> {op |> String.downcase |> String.to_atom, {parse_value(a), parse_value(b)}, target}
    end
  end

  def parse_value(value) do
    case Integer.parse(value) do
      :error -> {:pointer, value}
      {n, _} -> {:value, n}
    end
  end
end


ExUnit.start()

defmodule Day7Test do
  use ExUnit.Case

  import Day7

  test "part1" do
    instructions = """
      123 -> x
      456 -> y
      x AND y -> d
      x OR y -> e
      x LSHIFT 2 -> f
      y RSHIFT 2 -> g
      NOT x -> h
      NOT y -> i
      """

    assert part1(instructions) == %{
      d: 72,
      e: 507,
      f: 492,
      g: 114,
      h: 65412,
      i: 65079,
      x: 123,
      y: 456
    }
  end
end
