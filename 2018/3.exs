defmodule Day3 do
  def part1(instructions) do
    instructions |> go |> elem(0)
  end

  def part2(instructions) do
    {count, map} = instructions |> go

    set = MapSet.new([])

    Map.values(map)
    |> Enum.sort_by(&length/1)
    |> IO.inspect
    |> List.foldl(MapSet.new([]), fn ls, acc ->
      case ls do
        [x] -> MapSet.put(acc, x)
        ls  -> MapSet.difference(acc, MapSet.new(ls))
      end
    end)
    |> Enum.to_list
  end

  def go(instructions) do
    instructions
    |> parse
    |> List.foldl({0, %{}}, &apply_instruction/2)
  end

  def parse(str) do
    parsed =
      str
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_instruction/1)
  end

  def parse_instruction(str) do
    Regex.named_captures(~r/#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)/, str)
    |> Enum.map(fn {k, v} -> {String.to_atom(k), String.to_integer(v)} end)
    |> Map.new
  end

  def apply_instruction(%{:id => id, :x => x, :y => y, :w => w, :h => h} = instruction, acc) do
    col_range = Range.new(x, x + w - 1)
    line_range = Range.new(y, y + h - 1)

    list = for y <- line_range, x <- col_range, do: [x, y]

    list
    |> List.foldl(acc, fn cell, {count, map} ->
      case Map.get(map, cell, []) do
        [x] -> { count + 1, Map.put(map, cell, [id, x]) }
        []  -> { count, Map.put(map, cell, [id]) }
        list -> { count, Map.put(map, cell, [id | list]) }
      end
    end)
  end
end


ExUnit.start()

defmodule Tests do
  use ExUnit.Case

  import Day3

  test "part1" do
    instructions = """
      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 5,5: 2x2
      """

    assert part1(instructions) == 4

    instructions2 = """
      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 5,5: 2x2
      #4 @ 1,1: 6x6
      #5 @ 0,0: 1x1
    """
    assert part2(instructions2) == [5]

    File.read!("2018/files/3.txt")
    |> part1
    |> IO.inspect

    File.read!("2018/files/3.txt")
    |> part2
    |> IO.inspect
  end
end
