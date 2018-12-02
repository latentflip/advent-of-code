#!/usr/bin/env elixir

{:ok, body} = File.read "files/2.txt"


defmodule Ex1 do
    def identity(x) do x end

    def character_counts(word) do
        word
        |> String.split("", trim: true)
        |> Enum.group_by(&identity/1, &identity/1)
        |> Map.to_list
        |> Enum.map(fn({_, list}) -> length(list) end)
        |> List.foldl({0, 0}, fn(count, {twos, threes}) ->
            case count do
                2 -> {1, threes}
                3 -> {twos, 1}
                _ -> {twos, threes}
            end
        end)
    end

    def go(body) do
        String.split(body)
        |> Enum.map(&character_counts/1)
        |> List.foldl({0, 0}, fn({two, three}, {two_sum, three_sum}) -> {two_sum + two, three_sum + three} end)
        |> (fn({two_sum, three_sum}) -> two_sum * three_sum end).()
    end
end

split = fn(word) -> String.split(word, "", trime: true) end

defmodule Ex2 do
    # abcde -> [bcde, acde, abde, abce, abcd]
    def permute(string) do
        chars = String.split(string, "", trim: true)

        Range.new(0, length(chars) - 1)
        |> Enum.map(fn(i) ->
            {i, Enum.join(List.delete_at(chars, i), "")}
        end)
    end

    def check_or_set([next_word|rest], [], map) do
        check_or_set(rest, permute(next_word), map)
    end

    def check_or_set(words, [head|tail], map) do
        case Map.get(map, head, false) do
            false -> check_or_set(words, tail, Map.put(map, head, true))
            true -> head
        end
    end

    def go(body) do
        String.split(body)
        |> check_or_set([], %{})
        |> elem(1)
    end
end

test = """
abcde
fghij
klmno
pqrst
fguij
axcye
wvxyz
"""

IO.puts(Ex1.go(body))
IO.puts(Ex2.go(test))
IO.puts(Ex2.go(body))
