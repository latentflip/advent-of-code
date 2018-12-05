defmodule Day5 do
  def part1(str) do
    str
    |> String.trim
    |> String.to_charlist
    |> collide
    |> IO.inspect
    |> length
  end

  defp collide(list) do
    collide([], list)
  end

  defp collide(pre, [first|[peek|tail]]) do
    case abs(peek - first) do
      32 -> collide(Enum.reverse(pre) ++ tail)
      _  -> collide([first | pre], [peek|tail])
    end
  end

  defp collide(pre, [one]) do
    [one | pre]
  end

  defp collide(pre, []) do
    pre
  end

  def part2(str) do
    codes = str |> String.trim |> String.to_charlist

    chars = Range.new(?a,?n)

    pmap(chars, fn to_remove ->
      codes
      |> (fn x -> IO.inspect("Starting #{to_remove}"); x end).()
      |> Enum.reject(fn char ->
        diff = to_remove - char
        diff == 0 || diff == 32
      end)
      |> collide
      |> (fn x -> IO.inspect("Finished #{to_remove}"); x end).()
      |> length
    end)
    |> Enum.min
  end

  # Map in parallel, seems to half execution time
  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(fn t -> Task.await(t, 25000) end)
  end
end


ExUnit.start()

defmodule Tests do
  use ExUnit.Case

  import Day5

  test "part1" do
    instructions = """
      dabAcCaCBAcCcaDA
      """

    assert part1(instructions) == 10
    assert part2(instructions) == 4

    File.read!("2018/files/5.txt")
    |> part1
    |> IO.inspect

    File.read!("2018/files/5.txt")
    |> part2
    |> IO.inspect
  end
end
