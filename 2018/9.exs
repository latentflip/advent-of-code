defmodule Ring do
  def find_index(ring, item) do
    Enum.find_index(ring, fn x -> x == item end)
  end

  def insert_one_after(ring, from, value) do
    idx = find_index(ring, from)
    insert_idx = rem(idx + 2, length(ring))

    cond do
      insert_idx == 0 -> ring ++ [value]
      true -> List.insert_at(ring, insert_idx, value)
    end
  end

  def collect(ring, current) do
    idx_to_remove = find_index(ring, current) - 7
    idx_to_remove = cond do
      idx_to_remove < 0 -> length(ring) + idx_to_remove
      true -> idx_to_remove
    end
    collected = Enum.at(ring, idx_to_remove)
    ring = List.delete_at(ring, idx_to_remove)
    new_index = rem(idx_to_remove, length(ring))
    current = Enum.at(ring, new_index)
    IO.inspect({current, collected})
    {ring, collected, current}
  end
end

defmodule Day9 do
  def part1(players, max) do
    players = Range.new(0, players - 1) |> Enum.map(fn x -> {x, 0} end)
    turn = 0
    circle = []
    players = play({turn, max, 0, circle, players})

    players
    |> Enum.max_by(fn {n, score} -> score end)
    |> elem(1)
  end

  def play({turn, max, _, _, players}) when turn > max do
    players
  end

  # first move
  def play({turn, max, current, [], players}) do
    play({turn + 1, max, current, [turn], players})
  end

  def play({turn, max, current, circle, players}) when rem(turn, 23) == 0 do
    player_idx = rem(turn, length(players))
    {circle, collected, current} = Ring.collect(circle, current)
    players = List.update_at(players, player_idx, fn {n, score} -> {n, score + turn + collected } end)
    IO.inspect(players)
    play({turn + 1, max, current, circle, players})
  end

  def play({turn, max, current, circle, players}) do
    cond do
      rem(turn, 1000) == 0 -> IO.inspect(turn)
      true -> true
    end
    circle = Ring.insert_one_after(circle, current, turn)
    play({turn + 1, max, turn, circle, players})
  end
end

ExUnit.start(timeout: 120000)

defmodule Tests do
  use ExUnit.Case

  import Day9
  import Ring

  test "part1" do
    assert part1(9, 25) == 32
    IO.inspect({"Part 1", part1(486, 70833)})
  end

  test "ring" do
    assert insert_one_after([0], 0, 1) == [0,1]
    assert insert_one_after([0,1], 1, 2) == [0,2,1]
    assert insert_one_after([0,2,1], 2, 3) == [0,2,1,3]
  end
end
