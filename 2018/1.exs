#!/usr/bin/env elixir

{:ok, body} = File.read "files/1.txt"

nums = Enum.map(String.split(body), &String.to_integer/1)

IO.puts List.foldl(nums, 0, fn(x, acc) -> acc + x end)

defmodule Finder do
  def find_duplicate(list, map) do
    find_duplicate(list, map, 0)
  end

  def find_duplicate([head | tail], map, sum) do
    sum = sum + head

    map = Map.put(map, sum, 1)

    case Map.get(map, sum, 0) do
      1 -> IO.puts(sum)
      _ -> find_duplicate(tail ++ [head], map, sum)
    end
  end
end

IO.puts Finder.find_duplicate([1,-2,3,1], %{})
