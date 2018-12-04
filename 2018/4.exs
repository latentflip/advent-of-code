defmodule Day3 do
  def part1(str) do
    str
    |> split()
    |> Enum.map(&parse/1)
    |> Enum.sort_by(&sorter/1)
    |> List.foldl({nil, nil, %{}}, fn g, {current, state, map} ->
      case g do
        %{:action => :start, :id => id} -> {id, nil, Map.put_new(map, id, empty_day())}
        %{:action => :asleep} -> {current, g, map}
        %{:action => :awake} -> {current, nil, add_sleep(current, map, g, state)}
      end
    end)
    |> elem(2)
    |> Map.to_list
    |> Enum.max_by(fn {id, ls} -> Enum.sum(ls) end)
    |> (fn {id, ls} ->
      max = Enum.max(ls)
      id * Enum.find_index(ls, fn x -> x == max end)
    end).()
    |> IO.inspect
  end

  def part2(str) do
    str
    |> split()
    |> Enum.map(&parse/1)
    |> Enum.sort_by(&sorter/1)
    |> List.foldl({nil, nil, %{}}, fn g, {current, state, map} ->
      case g do
        %{:action => :start, :id => id} -> {id, nil, Map.put_new(map, id, empty_day())}
        %{:action => :asleep} -> {current, g, map}
        %{:action => :awake} -> {current, nil, add_sleep(current, map, g, state)}
      end
    end)
    |> elem(2)
    |> Map.to_list
    |> IO.inspect
    |> Enum.map(fn {id, ls} ->
      max = Enum.max(ls)
      {id, Enum.find_index(ls, fn x -> x == max end), max}
    end)
    |> IO.inspect
    |> Enum.max_by(fn {id, time, count} -> count end)
    |> (fn {id, time, count} -> id * time end).()
  end

  def split(str) do
    String.split(str, "\n", trim: true)
  end

  def add_sleep(id, map, awake, asleep) do
    %{"min" => from} = asleep
    %{"min" => to} = awake

    from = String.to_integer(from)
    to = String.to_integer(to)

    Map.update!(map, id, fn times ->
      times
      |> Enum.with_index
      |> Enum.map(fn {val, i} ->
        cond do
          from <= i && i < to -> val + 1
          true -> val
        end
      end)
    end)
  end

  def empty_day do
    0..59 |> Enum.map(fn _ -> 0 end)
  end

  def parse(str) do
    str |> IO.inspect
    map = Regex.named_captures(~r/\[(?<y>\d\d\d\d)-(?<m>\d\d)-(?<d>\d\d) (?<h>\d\d):(?<min>\d\d)] (?<log>.*)/, str)
    |> Map.update!("log", fn log ->
      case String.split(log, " ", trim: true) do
        ["falls", "asleep"] -> %{action: :asleep}
        ["wakes", "up"] -> %{action: :awake}
        ["Guard", n, "begins", "shift"] -> %{action: :start, id: String.to_integer(String.slice(n, 1..-1))}
      end
    end)

    Map.merge(Map.get(map, "log"), Map.delete(map, "log"))
  end

  def sorter(%{"y" => y, "m" => m, "d" => d, "h" => h, "min" => min}) do
    Enum.join([y,m,d,h,min], "")
    |> IO.inspect
  end

  def part2(instructions) do
  end
end


ExUnit.start()

defmodule Tests do
  use ExUnit.Case

  import Day3

  test "part1" do
    instructions = """
      [1518-11-01 00:00] Guard #10 begins shift
      [1518-11-03 00:05] Guard #10 begins shift
      [1518-11-01 00:25] wakes up
      [1518-11-01 00:30] falls asleep
      [1518-11-01 00:55] wakes up
      [1518-11-01 23:58] Guard #99 begins shift
      [1518-11-01 00:05] falls asleep
      [1518-11-02 00:40] falls asleep
      [1518-11-02 00:50] wakes up
      [1518-11-03 00:24] falls asleep
      [1518-11-03 00:29] wakes up
      [1518-11-04 00:02] Guard #99 begins shift
      [1518-11-04 00:36] falls asleep
      [1518-11-04 00:46] wakes up
      [1518-11-05 00:03] Guard #99 begins shift
      [1518-11-05 00:45] falls asleep
      [1518-11-05 00:55] wakes up
      """

    assert part1(instructions) == 240
    assert part2(instructions) == 4455

    File.read!("2018/files/4.txt")
    |> part1
    |> IO.inspect

    File.read!("2018/files/4.txt")
    |> part2
    |> IO.inspect
  end
end
