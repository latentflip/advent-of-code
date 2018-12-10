defmodule Day10 do
  def part1(str) do
    start_map = parse(str)
    min = find_min(start_map)

    advance_map(start_map, min)
    |> print
  end

  def find_min(map) do
    steps = Range.new(10400, 12000)
    Enum.min_by(steps, fn step ->
      keys = advance_map(map, step)
              |> Map.keys
      {{xmin,_},{xmax,_}} = Enum.min_max_by(keys, fn {px,_} -> px end)
      xmax - xmin
    end)
    |> IO.inspect
  end

  def advance_map(map, time) do
    Map.new(map, fn {{px,py},{vx,vy}} ->
      {{px + vx*time, py + vy*time},{vx, vy}}
    end)
  end

  def print(map) do
    keys = Map.keys(map)
    {{xmin,_},{xmax,_}} = Enum.min_max_by(keys, fn {px,_} -> px end)
    {{_,ymin},{_,ymax}} = Enum.min_max_by(keys, fn {_,py} -> py end)

    xs = Range.new(xmin, xmax)
    ys = Range.new(ymin, ymax)
    IO.ANSI.clear()
    Enum.each(ys, fn y ->
      Enum.each(xs, fn x ->
        cond do
          Map.has_key?(map, {x,y}) -> IO.write("#")
          true -> IO.write(".")
        end
      end)
      IO.puts("")
    end)
  end

  def parse(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_,px,py,_,vx,vy] = String.split(line, ~r/[<,>]/, trim: true)
      {{clean_int(px), clean_int(py)}, {clean_int(vx), clean_int(vy)}}
    end)
    |> Map.new
  end

  def clean_int(str) do
    String.trim(str) |> String.to_integer
  end
end

ExUnit.start(timeout: 120000)

defmodule Tests do
  use ExUnit.Case

  import Day10

  test "part1" do
    instructions = """
    position=< 9,  1> velocity=< 0,  2>
    position=< 7,  0> velocity=<-1,  0>
    position=< 3, -2> velocity=<-1,  1>
    position=< 6, 10> velocity=<-2, -1>
    position=< 2, -4> velocity=< 2,  2>
    position=<-6, 10> velocity=< 2, -2>
    position=< 1,  8> velocity=< 1, -1>
    position=< 1,  7> velocity=< 1,  0>
    position=<-3, 11> velocity=< 1, -2>
    position=< 7,  6> velocity=<-1, -1>
    position=<-2,  3> velocity=< 1,  0>
    position=<-4,  3> velocity=< 2,  0>
    position=<10, -3> velocity=<-1,  1>
    position=< 5, 11> velocity=< 1, -2>
    position=< 4,  7> velocity=< 0, -1>
    position=< 8, -2> velocity=< 0,  1>
    position=<15,  0> velocity=<-2,  0>
    position=< 1,  6> velocity=< 1,  0>
    position=< 8,  9> velocity=< 0, -1>
    position=< 3,  3> velocity=<-1,  1>
    position=< 0,  5> velocity=< 0, -1>
    position=<-2,  2> velocity=< 2,  0>
    position=< 5, -2> velocity=< 1,  2>
    position=< 1,  4> velocity=< 2,  1>
    position=<-2,  7> velocity=< 2, -2>
    position=< 3,  6> velocity=<-1, -1>
    position=< 5,  0> velocity=< 1,  0>
    position=<-6,  0> velocity=< 2,  0>
    position=< 5,  9> velocity=< 1, -2>
    position=<14,  7> velocity=<-2,  0>
    position=<-3,  6> velocity=< 2, -1>
    """

    File.read!("2018/files/10.txt")
    |> part1
  end
end
