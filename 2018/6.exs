defmodule Ls do
  def mminby(xs, fx) do
    List.foldl(xs, {:inf, []}, fn x, {min, mins} ->
      score = fx.(x)
      cond do
        min == :inf  -> {score, [x]}
        score == min -> {min, [x | mins]}
        score < min -> {score, [x]}
        true -> {min, mins}
      end
    end)
    |> elem(1)
  end
end

defmodule Day6 do
  def part1(str) do
    instructions = str
      |> parse()

    {{_, {xmin,_}}, {_, {xmax, _}}} = Enum.min_max_by(instructions, fn {p, {x,y}} -> x end)
    {{_, {_,ymin}}, {_, {_, ymax}}} = Enum.min_max_by(instructions, fn {p, {x,y}} -> y end)
    grid = %{}

    IO.inspect { {xmin, xmax}, {ymin, ymax} }

    points = for x <- Range.new(xmin, xmax), y <- Range.new(ymin, ymax), do: {x, y}

    edges = for x <- Range.new(xmin, xmax),
                y <- Range.new(ymin, ymax),
                x == xmin || x == xmax || y == ymin || y == ymax,
                do: {x, y}

    grid = points
    |> List.foldl(%{}, fn p, grid ->
      closest = Ls.mminby(instructions, fn {n, ins} -> manhattan_dist(ins, p) end)
      case closest do
        [{i, c}] -> Map.put(grid, p, i)
        _        -> Map.put(grid, p, :x)
      end
    end)

    edge_points = edges
    |> Enum.map(fn edge -> Map.get(grid, edge) end)
    |> Enum.uniq

    counts =
      Map.values(grid)
      |> Enum.group_by(fn x -> x end)
      |> Map.new(fn {k, v} -> {k, length(v)} end)
      |> Map.drop([:x | edge_points])
      |> Map.to_list
      |> Enum.max_by(fn {k, v} -> v end)
      |> elem(1)
  end

  def part2(str, dist) do
    instructions = str
      |> parse()

    {{_, {xmin,_}}, {_, {xmax, _}}} = Enum.min_max_by(instructions, fn {p, {x,y}} -> x end)
    {{_, {_,ymin}}, {_, {_, ymax}}} = Enum.min_max_by(instructions, fn {p, {x,y}} -> y end)
    grid = %{}

    points = for x <- Range.new(xmin, xmax), y <- Range.new(ymin, ymax), do: {x, y}

    points
    |> List.foldl(0, fn pcoord, n ->
      tdist = instructions
      |> Enum.map(fn {i, icoord} -> manhattan_dist(pcoord, icoord) end)
      |> Enum.sum

      cond do
        tdist < dist -> n + 1
        true -> n
      end
    end)
  end

  def add_to_grid({p, coord}, {from, to, grid}) do
    {from, to, Map.update(grid, coord, p, fn x -> :x end)}
  end

  def parse(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.map(fn {x, n} ->
      {
        n,
        x |> String.split(", ") |> Enum.map(&String.to_integer/1) |> List.to_tuple
      }
    end)
  end

  def permute({p, {px, py}}, distance) do
    range = Range.new(-1 * distance, distance)
    for x <- range,
        y <- range,
        abs(x) + abs(y) == distance,
        do: {p, {px + x, py + y}}
  end

  def manhattan_dist({x1,y1}, {x2,y2}) do
    abs(x2 - x1) + abs(y2 - y1)
  end

  def part2(str) do
  end
end

ExUnit.start()

defmodule Tests do
  use ExUnit.Case

  import Day6

  test "part1" do
    instructions = """
      1, 1
      1, 6
      8, 3
      3, 4
      5, 5
      8, 9
      """

    assert part1(instructions) == 17
    assert part2(instructions, 32) == 16

    File.read!("2018/files/6.txt")
    |> part1
    |> IO.inspect

    IO.inspect "Part 2"
    File.read!("2018/files/6.txt")
    |> part2(10000)
    |> IO.inspect
  end
end
