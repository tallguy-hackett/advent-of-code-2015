defmodule Lights do
  def get_lit_lights(filename) do
    filename
    |> File.stream!()
    |> Enum.reduce(HashSet.new, &parse_instruction/2)
    |> Enum.count()
  end

  def parse_instruction("turn on " <> coords, current_lights) do
    coords
    |> destructure_coord_string()
    |> turn_on(current_lights)
  end

  def parse_instruction("toggle " <> coords, current_lights) do
    coords
    |> destructure_coord_string()
    |> toggle(current_lights)
  end

  def parse_instruction("turn off " <> coords, current_lights) do
    coords
    |> destructure_coord_string()
    |> turn_off(current_lights)
  end

  defp destructure_coord_string(coord_string) do
    coord_string
    |> String.strip()
    |> String.split(" through ")
    |> Enum.map(&parse_coordinates/1)
  end

  defp parse_coordinates(coord_string) do
    coord_string
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp turn_on([{x1, y1}, {x2, y2}], current_lights) do
    create_grid(x1, y1, x2, y2)
    |> Enum.reduce(current_lights, fn(coord, acc) -> Set.put(acc, coord) end)
  end

  defp toggle([{x1, y1}, {x2, y2}], current_lights) do
    create_grid(x1, y1, x2, y2)
    |> Enum.reduce(current_lights, fn(coord, acc) ->
                                      if(Set.member?(acc, coord)) do
                                        Set.delete(acc, coord)
                                      else
                                        Set.put(acc, coord)
                                      end end)
  end

  defp turn_off([{x1, y1}, {x2, y2}], current_lights) do
    create_grid(x1, y1, x2, y2)
    |> Enum.reduce(current_lights, fn(coord, acc) -> Set.delete(acc, coord) end)
  end

  defp create_grid(x1, y1, x2, y2) do
    x1..x2
    |> Enum.map(&(create_grid(&1, y1, y2)))
    |> List.flatten()
  end

  defp create_grid(x, y1, y2) do
    y1..y2
    |> Enum.map(&({x, &1}))
  end
end

light_count = Lights.get_lit_lights("instructions.txt")
IO.puts "There are #{light_count} lights that are lit"