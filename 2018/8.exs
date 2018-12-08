defmodule Day7 do
  def part1(str) do
    str |> make_tree |> sum_meta
  end

  def part2(str) do
    str |> make_tree |> sum_children
  end

  def make_tree(str) do
    str
    |> String.trim
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> parse_node()
    |> elem(0)
  end

  def parse_node([child_count|[meta_count|rest]]) do
    {children, rest} = take_children(rest, child_count)
    {meta,rest} = Enum.split(rest, meta_count)
    {{children, meta}, rest}
  end

  def take_children(ls, count) do
    take_children(ls, count, [])
  end

  def take_children(ls, count, result) do
    case count do
      0 -> {result, ls}
      n -> {child, rest} = parse_node(ls); take_children(rest, count - 1, result ++ [child])
    end
  end

  def sum_meta({children, meta}) do
    sum_meta([{children, meta}])
  end

  def sum_meta([{children, meta}|tail]) do
    Enum.sum(meta) + sum_meta(children) + sum_meta(tail)
  end

  def sum_meta([]) do
    0
  end


  # part 2
  def sum_children({[], meta}) do
    Enum.sum(meta)
  end

  def sum_children({children, meta}) do
    meta
    |> Enum.map(fn idx -> sum_children(Enum.at(children, idx - 1)) end)
    |> Enum.sum
  end

  def sum_children(nil) do
    0
  end
end

ExUnit.start()

defmodule Tests do
  use ExUnit.Case

  import Day7

  test "part1" do
    instructions = """
      2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
      """

    assert part1("0 3 10 20 30") == 60
    assert part1("1 0 0 3 10 20 30") == 60
    assert part1("1 1 0 3 10 20 30 5") == 65
    assert part1("2 0 0 1 5 0 1 6") == 11

    assert part1(instructions) == 138
    assert part2(instructions) == 66

    File.read!("2018/files/8.txt")
    |> part1
    |> IO.inspect

    IO.inspect "Part 2"
    File.read!("2018/files/8.txt")
    |> part2
    |> IO.inspect
  end
end
