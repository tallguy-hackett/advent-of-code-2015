defmodule Wrapping do
  def total_wrapping_paper(filename) do
    parse_dimension_file(filename)
    |> Enum.map(&calculate_wrapping_paper_required/1)
    |> Enum.sum()
  end

  def total_ribbon(filename) do
    parse_dimension_file(filename)
    |> Enum.map(&calculate_ribbon_required/1)
    |> Enum.sum()
  end

  def parse_dimension_file(filename) do
    present_stream = File.stream!(filename)
    present_stream
    |> Enum.map(&parse_dimension/1)
  end

  def parse_dimension(present_dimension_line) do
    present_dimension_line
    |> String.strip()
    |> String.split("x")
    |> Enum.map(&String.to_integer/1)
  end

  def calculate_wrapping_paper_required([length, width, height]) do
    side_areas = [length*width, width*height, length*height]
    Enum.sum(side_areas) * 2 + Enum.min(side_areas)
  end

  def calculate_ribbon_required(dimensions) do
    [length, width, height] = dimensions
    perimeters = [(2*length + 2*width), (2*width + 2*height), (2*length + 2*height)]
    Enum.min(perimeters) + (Enum.reduce(dimensions, &(&1*&2)))
  end
end

total_wrapping_required = Wrapping.total_wrapping_paper("present_dimensions.txt")
IO.puts("The elves need #{total_wrapping_required} sq feet of wrapping paper")

total_ribbon_required = Wrapping.total_ribbon("present_dimensions.txt")
IO.puts("The elves need #{total_ribbon_required} feet of ribbon")
