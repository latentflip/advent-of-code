defmodule Day13 do
  def part1(str) do
    str
    |> parse
    |> iterate
  end

  def part2(str) do
    str
    |> parse
    |> iterate2
  end

  def parse(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> List.foldl({[], %{}}, fn {l,y}, board ->
      List.foldl(
        String.codepoints(l) |> Enum.with_index,
        board,
        fn {c,x}, {cars, points} ->
          case c do
            ">" -> {
              [{{x,y}, 90, :left}|cars],
              Map.put(points, {x,y}, "-")
            }
            "v" -> {
              [{{x,y}, 180, :left}|cars],
              Map.put(points, {x,y}, "|")
            }
            "<" -> {
              [{{x,y}, 270, :left}|cars],
              Map.put(points, {x,y}, "-")
            }

            "^" -> {
              [{{x,y}, 0, :left}|cars],
              Map.put(points, {x,y}, "|")
            }
            " " -> {cars, points}
            _   -> {cars, Map.put(points, {x,y}, c)}
          end
        end
      )
    end)
  end

  def iterate({cars, points}) do
    cars = cars |> sort_cars
    advanced = advance_and_collide([], cars, points)

    case advanced do
      {:found, location} -> location
      cars -> iterate({cars, points})
    end
  end

  def iterate2({cars, points}) do
    cars = cars |> sort_cars
    advanced = advance_and_remove([], cars, points)
    case advanced do
      [{p,_,_}] -> p
      cars -> iterate2({ cars, points })
    end
  end

  def advance_and_remove(moved, [], points) do
    moved
  end

  def advance_and_remove(moved, [next|rest], points) do
    next = advance(next, points)
    {pn, _, _} = next

    moved_f = Enum.reject(moved, fn {p,_,_} -> p == pn end)
    rest_f = Enum.reject(rest, fn {p,_,_} -> p == pn end)

    cond do
      length(moved_f) < length(moved) -> advance_and_remove(moved_f, rest, points)
      length(rest_f) < length(rest) -> advance_and_remove(moved, rest_f, points)
      true -> advance_and_remove([next|moved], rest, points)
    end
  end

  def advance_and_collide({:found, c}, _, _) do
    {:found, c}
  end

  def advance_and_collide(moved, [], points) do
    moved
  end

  def advance_and_collide(moved, [next|rest], points) do
    next = advance(next, points)
    {pn,_,_} = next
    cond do
      Enum.any?(moved, fn {p,_,_} -> pn == p end) -> {:found, pn}
      Enum.any?(rest, fn {p,_,_} -> pn == p end) -> {:found, pn}
      true -> advance_and_collide([next|moved], rest, points)
    end
  end

  def advance({{x,y}, direction, turn}, points) do
    new_loc = update_point({x,y}, direction)
    intersect({new_loc, direction, turn}, Map.get(points, new_loc))
  end

  def update_point({x,y}, direction) do
    case direction do
      0 -> {x, y-1}
      90 -> {x+1, y}
      180 -> {x, y+1}
      270 -> {x-1, y}
    end
  end

  def intersect({pos, direction, turn} = car, char) do
    case char do
      "|" -> car
      "-" -> car
      "/" -> corner(car, char)
      "\\" -> corner(car, char)
      "+" -> cross(car)
    end
  end

  def corner({pos, direction, turn}, char) do
    case {direction, char} do
      {0, "/"} -> {pos, 90, turn}
      {90, "/"}  -> {pos, 0, turn}
      {180, "/"} -> {pos, 270, turn}
      {270, "/"}  -> {pos, 180, turn}

      {0, "\\"} -> {pos, 270, turn}
      {90, "\\"}  -> {pos, 180, turn}
      {180, "\\"} -> {pos, 90, turn}
      {270, "\\"}  -> {pos, 0, turn}
    end
  end

  def cross({pos, direction, turn}) do
    case {direction, turn} do
      {n, :left} -> {pos, rem(n + 270, 360), :straight}
      {_, :straight}   -> {pos, direction, :right}
      {n, :right} -> {pos, rem(n + 90, 360), :left}
    end
  end

  def sort_cars(cars) do
    cars
    |> Enum.sort(fn a, b ->
      {{xa,ya},_,_} = a
      {{xb,yb},_,_} = b
      cond do
        ya < yb -> true
        ya > yb -> false
        true    -> xa <= xb
      end
    end)
  end
end

ExUnit.start(timeout: 120000)

defmodule Tests do
  use ExUnit.Case

  import Day13

  test "part1" do
    instructions = ~S(
/->-\
|   |  /----\
| /-+--+-\  |
| | |  | v  |
\-+-/  \-+--/
  \------/)

    {cars, points} = parse(instructions)
    assert [
      {{9,3}, 180, :left},
      {{2,0}, 90, :left}
    ] == cars

    assert Map.get(points, {2,4}) == "+"

    assert part1(instructions) == {7,3}


    instructions2 = ~S(
/>-<\
|   |
| /<+-\
| | | v
\>+</ |
  |   ^
  \<->/)
    assert part2(instructions2) == {6,4}

    File.read!("2018/files/13.txt")
    |> part1
    |> IO.inspect

    File.read!("2018/files/13.txt")
    |> part2
    |> IO.inspect
  end
end
