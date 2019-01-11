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

    defmodule Input do
      defstruct x: 0, y: 0, name: nil
    end

    def parse_line({l, i}) do
      [x, y] = String.split(l, ", ")

      {a, _} = Integer.parse(x)
      {b, _} = Integer.parse(y)
      c = ?i + 65
      %Input{x: a, y: b, name: c}
    end

    @spec parse_string_input(list(binary)) :: [Input.t]
    def parse_string_input(s) do
       Enum.with_index(s) |> Enum.map(&parse_line/1)
    end

    def bounding_box(inputs) do
      xs = Enum.map(inputs, &(Map.get(&1, :x)))
      {min_x, max_x} = xs |> Enum.min_max()

      ys = Enum.map(inputs, &(Map.get(&1, :y)))
      {min_y, max_y} = ys |> Enum.min_max()

      {{min_x - 1, min_y - 1}, {max_x + 1, max_y + 1}}
    end

    defmodule GridCell do
      defstruct x: 0, y: 0, p: :interior, nearest: :unset
    end

    def grid({{x1, y1}, {x2, y2}}) do
      for x <- x1..x2, y <- y1..y2 do
        p = case {x, y} do
          _ when x in [x1, x2] or y in [y1, y2] ->
            :exterior
          _ ->
            :interior
        end
        %GridCell{x: x, y: y, p: p}
      end
    end

    def make(input_list) do
      i = parse_string_input(input_list)
      b = bounding_box(i)
      g = grid(b)
      %Day6{inputs: i, bounding_box: b, grid: g}
    end

    def nearest(%GridCell{x: px, y: py}, inputs) do
      Enum.map(inputs, fn {%Input{x: x, y: y} = ix, i} ->
        %{distance: abs(x - px) + abs(y - py), idx: ix}
      end)
      |> Enum.sort_by(fn %{distance: d} -> d end)
      |> List.first()
    end

    def set_nearest(%Day6{grid: g, inputs: i} = d) do
      indexed = Enum.with_index(i)
      updated_grid = for p <- g do
        %{idx: idx} = nearest(p, indexed)
        %{p | nearest: idx}
      end

      %{d | grid: updated_grid}
    end

    def is_input(grid_cell, inputs) do
      Enum.find(inputs, fn i ->
        i.x == grid_cell.x && i.y == grid_cell.y
      end)
    end

    def pretty_print(%Day6{grid: g, bounding_box: b, inputs: i}) do
      {{x1, _}, {x2, _}} = b
      IO.puts("#{x2 + 1 - x1} cells wide")
      Enum.chunk_every(g, x2 - x1 + 1)
      |> Enum.map_join("\n", fn row ->
        Enum.map(row, fn c ->
          if c.nearest.x == c.x && c.nearest.y == c.y do
          else
            c.nearest
          end
        end&(&1.nearest + 97)) |> List.to_string()
      end)
    end

    def nearest_groups(%Day6{grid: g}) do
      g |> Enum.group_by(fn %GridCell{nearest: n} -> n end)
    end

    def interior_groups(group_map) do
      :maps.filter(fn _, v ->
        Enum.all?(v, fn %GridCell{p: p} -> p == :interior end)
      end, group_map)
    end

    def process(i) do
      day6 = i
      |> make()
      |> set_nearest()

      IO.inspect(day6.bounding_box, label: :bounds)

      day6
      |> nearest_groups()
      |> interior_groups()
      |> Map.to_list()
      |> Enum.map(fn {k, v} -> {k, length(v)} end)
      |> Enum.sort_by(fn {_, v} -> v end)
      |> Enum.reverse()
      |> IO.inspect(label: :foo)
      |> hd()
    end

    def part1() do
      Advent.read_file(6)
      |> process()
    end
  end
end
