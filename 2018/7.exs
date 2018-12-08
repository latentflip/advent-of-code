defmodule Day7 do
  def part1(str) do
    map = str
    |> parse
    |> with_deps

    iterate(map, [])
  end

  def part2(str, workers, worktime) do
    map = str
    |> parse
    |> with_deps

    workers = Range.new(0, workers - 1) |> Enum.map(fn _ -> {:idle, nil} end)
    tick(0, map, workers, worktime)
  end

  def tick(time, map, workers, worktime) do
    {completed, available, working} = List.foldl(workers, {MapSet.new, [], []}, fn worker, {c, a, w} ->
      case worker do
        {:idle,_} -> {c, [worker|a], w}
        {key, 0} -> {MapSet.put(c, key), [worker|a], w}
        {key, n} -> {c, a, [{key, n-1}|w]}
      end
    end)

    map = Map.new(map, fn {k, v} -> {k, MapSet.difference(v, completed)} end)

    candidates = Enum.filter(map, fn {k, deps} -> MapSet.size(deps) == 0 end)
                      |> Enum.map(fn {k, deps} -> k end)
                      |> Enum.sort

    {now_working, idle, map, _} = List.foldl(available, {[], [], map, candidates}, fn w, {ws, idle, map, cands} ->
      cond do
        map == %{}         -> {ws, [w|idle], map, cands}
        length(cands) == 0 -> {ws, [w|idle], map, cands}
        true ->
          [key|cands] = cands
          {[{key, get_time(key, worktime) - 1} | ws], idle, Map.delete(map, key), cands}
      end
    end)

    workers = now_working ++ idle ++ working

    cond do
      map == %{} && length(idle) == length(workers) -> time
      true -> tick(time + 1, map, workers, worktime)
    end
  end

  def get_time(key, worktime) do
    :binary.first(key) - ?A + 1 + worktime
  end

  def iterate(map, order) when map == %{} do
    Enum.join(order, "")
  end

  def iterate(map, order) do
    {next, rest} = run_next(map)
    order = order ++ [next]
    iterate(rest, order)
  end

  def run_next(map) do
    key = Enum.filter(map, fn {k, deps} -> MapSet.size(deps) == 0 end)
                |> Enum.map(fn {k, deps} -> k end)
                |> Enum.sort
                |> hd
    {key, remove_key(map, key)}
  end

  def remove_key(map, key) do
    Map.delete(map, key)
    |> Map.new(fn {k, v} -> {k, MapSet.delete(v, key)} end)
  end

  def parse(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      [_,dep,_,_,_,_,_,step,_,_] = x |> String.split(" ", trim: true)
      {step, dep}
    end)
  end

  def all_steps(instructions) do
    instructions
    |> Enum.map(&Tuple.to_list/1)
    |> List.flatten
    |> Enum.uniq
    |> Enum.sort
  end

  def with_deps(instructions) do
    instructions
    |> all_steps
    |> Enum.map(fn step ->
      {
        step,
        List.foldl(instructions, MapSet.new, fn ins, deps ->
          case ins do
            {^step, dep} -> MapSet.put(deps, dep)
            _ -> deps
          end
        end)
      }
    end)
    |> Map.new
  end
end

ExUnit.start()

defmodule Tests do
  use ExUnit.Case

  import Day7

  test "part1" do
    instructions = """
      Step C must be finished before step A can begin.
      Step C must be finished before step F can begin.
      Step A must be finished before step B can begin.
      Step A must be finished before step D can begin.
      Step B must be finished before step E can begin.
      Step D must be finished before step E can begin.
      Step F must be finished before step E can begin.
      """

    assert parse("""
      Step C must be finished before step A can begin.
      Step C must be finished before step F can begin.
      Step A must be finished before step B can begin.
    """) == [{"A", "C"}, {"F", "C"}, {"B", "A"}]

    assert all_steps(parse(instructions)) === String.split("ABCDEF", "", trim: true)

    assert part1(instructions) == "CABDFE"

    File.read!("2018/files/7.txt")
    |> part1
    |> IO.inspect

    assert part2(instructions, 2, 0) == 15

    IO.inspect "Part 2"
    File.read!("2018/files/7.txt")
    |> part2(5, 60)
    |> IO.inspect
  end
end
