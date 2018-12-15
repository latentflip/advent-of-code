defmodule Parallel do
  # Allows mapping over a collection using N parallel processes
  def map(collection, function) do
    # Get this process's PID
    me = self
    collection
    |>
    Enum.map(fn (elem) ->
      IO.inspect({"LOAD", elem})
      # For each element in the collection, spawn a process and
      # tell it to:
      # - Run the given function on that element
      # - Call up the parent process
      # - Send the parent its PID and its result
      # Each call to spawn_link returns the child PID immediately.
      spawn_link fn -> (send me, { self, function.(elem) }) end
    end) |>
    # Here we have the complete list of child PIDs. We don't yet know
    # which, if any, have completed their work
    Enum.map(fn (pid) ->
      # For each child PID, in order, block until we receive an
      # answer from that PID and return the answer
      # While we're waiting on something from the first pid, we may
      # get results from others, but we won't "get those out of the
      # mailbox" until we finish with the first one.
      receive do { ^pid, result } -> result end
    end)
  end
end

defmodule Day11 do
  def part1(serial) do
    map = Enum.flat_map(1..300, fn x ->
      Enum.map(1..300, fn y ->
        {{x,y}, power_level({x,y}, serial)}
      end)
    end)
    |> Map.new

    # Print the map
    # Enum.each(1..300, fn y ->
    #   Enum.each(1..300, fn x ->
    #     v = Map.get(map, {x,y}, 0)
    #     cond do
    #       v > 0 -> IO.write(IO.ANSI.red()); IO.write(String.pad_leading("#{v}", 3, " "))
    #       true -> IO.ANSI.white()); IO.write(String.pad_leading("#{v}", 3, " "))
    #     end
    #   end)
    #   IO.puts("")
    # end)

    Map.keys(map)
    |> Enum.max_by(fn c -> sum(map, c, 3) end)
    |> IO.inspect
  end

  def part2(serial) do
    map = Enum.flat_map(1..300, fn x ->
      Enum.map(1..300, fn y ->
        {{x,y}, power_level({x,y}, serial)}
      end)
    end)
    |> Map.new

    Map.keys(map)
    |> Enum.with_index
    |> Enum.map(fn {p,i} ->
      if rem(i, 1000) == 0 do
        IO.inspect(i)
      end
      {x,y} = p
      Range.new(50, 51)
      |> Enum.reduce({:x,:x,-1000}, fn d, {_,_,prev_sum} = prev ->
        new_sum = sum(map, p, d)
        cond do
          new_sum > prev_sum -> {p,d,new_sum}
          true -> prev
        end
      end)
      if rem(i, 1000) == 0 do
        IO.inspect("done #{i}")
      end
    end)
    |> IO.inspect

    # keys = Map.keys(map)

    # Range.new(50, 51)
    # |> Enum.map(fn dx ->
    #   IO.inspect(dx)
    #   keys
    #   |> Enum.reduce({:x, :x, -1000}, fn point, {_, _, prev_sum} = prev ->
    #     IO.inspect(point)
    #     new_sum = sum(map, point, dx)
    #     cond do
    #       new_sum > prev_sum -> {point,dx,new_sum}
    #       true -> prev
    #     end
    #   end)
    #   IO.inspect(dx)
    # end)
    # |> IO.inspect
  end

  def sum(map, {x,y}, n) do
    Enum.flat_map(0..(n-1), fn dx ->
      Enum.map(0..(n-1), fn dy ->
        Map.get(map, {x+dx, y+dy}, 0)
      end)
    end)
    |> Enum.sum
  end

  def power_level({x,y}, serial_no) do
    rack_id = x + 10
    power_level = rack_id * (rack_id * y + serial_no)
    hundreds = rem(trunc(Float.floor(power_level / 100)), 10)
    hundreds - 5
  end
end

ExUnit.start(timeout: 120000)

defmodule Tests do
  use ExUnit.Case

  import Day11

  test "part1" do
    # assert power_level({3,5}, 8) == 4
    # assert power_level({122,79}, 57) == -5
    # assert power_level({217,196}, 39) == 0

    # assert part1(18) == {33,45}
    # assert part1(42) == {21,61}
    # IO.inspect({"part1", part1(8444)})
    # part1(8444)
    part2(8444)
  end
end
