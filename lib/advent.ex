defmodule Advent do
  @moduledoc """
  Documentation for Advent.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Advent.hello()
      :world

  """
  def hello do
    :world
  end

  def read_file(id) do
    {:ok, s} =
      Path.expand("./inputs/#{id}.txt")
      |> IO.inspect(label: "file path")
      |> File.read()

    String.split(s, "\n")
  end

  defmodule Day5 do
    @spec react(charlist()) :: [any()]
    def react(s) do
      Enum.reduce(s, [], &react/2)
      |> Enum.reverse()
    end

    def react(char, acc) do
      case acc do
        [] ->
          [char]

        [h | t] when h + 32 === char or h - 32 === char ->
          t

        [_h | _] ->
          [char | acc]
      end
    end

    def remove_pair(charlist, lower) do
      upper = lower - 32
      Enum.reject(charlist, &(&1 == upper or &1 == lower))
    end

    def part1() do
      Advent.read_file(5)
      |> List.first()
      |> to_charlist()
      |> react()
      |> length()
    end

    def part2() do
      s = Advent.read_file(5) |> List.first() |> to_charlist()

      Enum.map(?a..?z, fn x ->
        remove_pair(s, x) |> react() |> length()
      end)
      |> Enum.sort()
    end
  end

  defmodule Day6 do
    defstruct inputs: [], bounding_box: nil, grid: []
    def sample_input() do
      ["1, 1", "1, 6", "8, 3", "3, 4", "5, 5", "8, 9"]
    end

    def parse_line(l) do
      [x, y] = String.split(l, ", ")

      {a, _} = Integer.parse(x)
      {b, _} = Integer.parse(y)
      {a, b}
    end

    def inputs(s), do: Enum.map(s, &parse_line/1)

    def bounding_box(i) do
      xs = Enum.map(i, &elem(&1, 0))
      {min_x, max_x} = xs |> Enum.min_max()

      ys = Enum.map(i, &elem(&1, 1))
      {min_y, max_y} = ys |> Enum.min_max()

      {{min_x - 1, min_y - 1}, {max_x + 1, max_y + 1}}
    end

    def grid({{x1, y1}, {x2, y2}}) do
      for x <- x1..x2, y <- y1..y2 do
        p = case {x, y} do
          _ when x in [x1, x2] or y in [y1, y2] ->
            :exterior
          _ ->
            :interior
        end
        {{x, y}, p}
      end
    end

    def make(input_list) do
      i = inputs(input_list) |> Enum.with_index()
      b = bounding_box(i)
      g = grid(b)
      %Day6{inputs: i, bounding_box: b, grid: g}
    end

    def nearest({px, py}, inputs) do
      Enum.map(inputs, fn {{x, y}, i} ->
        {abs(x - px) + abs(y - py), i}
      end)
      |> Enum.sort_by(fn {d, _} -> d end)
      |> List.first()
    end
  end
end
