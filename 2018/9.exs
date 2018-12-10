defmodule Ring do
  def play_one({next_marble, ring}) do
    ring = ring |> advance

    ring = case ring do
      {ls, [r]} -> {[r|ls], [next_marble]}
      {ls, [r|rs]} -> {[r|ls], [next_marble|rs]}
    end
    {next_marble + 1, ring}
  end

  # only one
  def advance({ls, [n]}) do
    {[], Enum.reverse([n|ls])}
  end

  def advance({ls, [n|rs]}) do
    {[n|ls], rs}
  end

  def reverse7(board) do
    board |> reverse |> reverse |> reverse |> reverse |> reverse |> reverse |> reverse
  end

  def reverse({[l|ls], rs}) do
    {ls, [l|rs]}
  end

  def reverse({[], rs}) do
    [r|ls] = Enum.reverse(rs)
    {ls, [r]}
  end

  def remove_current({ls, [r|rs]}) do
    {r, {ls, rs}}
  end
end


defmodule Day9 do
  def part1(players, max) do
    players = Range.new(0, players - 1) |> Enum.map(fn x -> {x, 0} end)
    board = {1, {[], [0]}}
    play(board, players, max)
    |> Enum.max_by(fn {n, score} -> score end)
    |> elem(1)
  end

  def play({next_val,board}, players, max) when next_val == max do
    players
  end

  def play({next_val,board}, players, max) when rem(next_val, 23) == 0 do
    board = Ring.reverse7(board)
    {collected, board} = Ring.remove_current(board)
    player_idx = rem(next_val, length(players))
    players = List.update_at(players, player_idx, fn {n, score} -> {n, score + next_val + collected } end)
    play({next_val + 1, board}, players, max)
  end

  def play(board, players, max) do
    Ring.play_one(board)
      |> play(players, max)
  end
end

ExUnit.start(timeout: 120000)

defmodule Tests do
  use ExUnit.Case

  import Day9
  import Ring

  test "part1" do
    assert advance({[], [0]}) == {[], [0]}

    x = {[], [0,1,2]} |> advance
    assert x == {[0], [1,2]}
    x = advance(x)
    assert x == {[1,0], [2]}
    x = advance(x)
    assert x == {[], [0,1,2]}

    y = {1, {[], [0]}}
    y = play_one(y)
    assert y == {2, {[0], [1]}}
    y = play_one(y)
    assert y == {3, {[0], [2,1]}}

    # -3 -2 -1 0 1 2 3
    x = {[], [-3, -2, -1, 0, 1, 2, 3]}
    x = x |> advance |> advance |> advance
    assert x == {[-1, -2, -3], [0, 1, 2, 3]}

    x = x |> reverse
    assert x == {[-2, -3], [-1, 0, 1, 2, 3]}

    x = x |> reverse
    assert x == {[-3], [-2,-1, 0, 1, 2, 3]}

    x = x |> reverse
    assert x == {[], [-3, -2,-1, 0, 1, 2, 3]}

    x = x |> reverse
    assert x == {[2, 1, 0, -1, -2, -3], [3]}

    assert part1(9, 25) == 32
    assert part1(10, 1618) == 8317
    assert part1(486, 70833) == 373597
    IO.inspect(part1(486, 7083300))
  end
end
