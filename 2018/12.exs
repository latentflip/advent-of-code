

defmodule Day10 do
  def part1(str) do
    str
    |> parse
    |> iterate(20)
  end

  def parse(str) do
    [initial|rest] = str
      |> String.trim
      |> String.split("\n", trim: true)

    [_, _, initial_state] = String.split(initial, " ", trim: true)

    instructions = rest
      |> Enum.map(fn s ->
        [l, r] = s |> String.split(" => ", trim: true)
        { String.codepoints(l), r}
      end)
      |> List.foldl(%{}, &add_to_tree/2)

    {String.codepoints("..#{initial_state}.."), instructions}
  end

  def add_to_tree({[hd], result}, map) do
    Map.put(map, hd, result)
  end

  def add_to_tree({[hd|rest], result}, map) do
    cond do
      Map.has_key?(map, hd) -> Map.update!(map, hd, fn child ->
                                 tree = add_to_tree({rest, result}, child)
                               end)
      true -> Map.put(map, hd, add_to_tree({rest, result}, %{}))
    end
  end

  def iterate({state, instructions}, count) do
    state = state
    |> Enum.with_index
    |> List.foldl([], fn {char, i}, arr ->
      (arr |> Enum.with_index |> Enum.map(fn {t,y} ->
        if y <= i and length(t) < 5 do
          t ++ [char]
        else
          t
        end
      end)) ++ [[char]]
    end)
    |> Enum.map(fn path ->
      get_in(instructions, path) || "."
    end)
    |> Enum.slice(0..-3)

    IO.inspect({count, state})
    if count > 0 do
      iterate({[".", "."] ++ state ++ [".", "."], instructions}, count - 1)
    else
      Enum.join(state, "")
    end
  end
end

ExUnit.start(timeout: 120000)

defmodule Tests do
  use ExUnit.Case

  import Day10

  test "part1" do
    instructions = """
    initial state: #..#.#..##......###...###

    ...## => #
    ..#.. => #
    .#... => #
    .#.#. => #
    .#.## => #
    .##.. => #
    .#### => #
    #.#.# => #
    #.### => #
    ##.#. => #
    ##.## => #
    ###.. => #
    ###.# => #
    ####. => #
    """

    assert part1(instructions)
    |> IO.inspect

    # File.read!("2018/files/12.txt")
    # |> part1
  end
end
