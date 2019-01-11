defmodule Mix.Tasks.Advent do
  use Mix.Task

  def run(args) do
    IO.inspect(args, label: :args)
    result = case args do
      ["5", "1"] -> Advent.Day5.part1()
      ["5", "2"] -> Advent.Day5.part2()
      ["6", "1"] -> Advent.Day6.part1()
      _ -> "Unknown arguments: #{Enum.join(args, " ")}"
    end
    Mix.shell.info "#{inspect(result)}"
  end
end
