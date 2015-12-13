defmodule Delivery do
  def get_house_path(filename) do
    File.read!(filename)
    |> String.to_char_list()
    |> move({0, 0}, [{0, 0}])
  end

  def move([], _last_house, house_path), do: Enum.reverse(house_path)
  def move([?^ | rest_of_instructions], {last_x, last_y}, house_path) do
    next_house = {last_x, last_y + 1}
    move(rest_of_instructions, next_house, [next_house | house_path])
  end
  def move([?< | rest_of_instructions], {last_x, last_y}, house_path) do
    next_house = {last_x - 1, last_y}
    move(rest_of_instructions, next_house, [next_house | house_path])
  end
  def move([?> | rest_of_instructions], {last_x, last_y}, house_path) do
    next_house = {last_x + 1, last_y}
    move(rest_of_instructions, next_house, [next_house | house_path])
  end
  def move([?v | rest_of_instructions], {last_x, last_y}, house_path) do
    next_house = {last_x, last_y - 1}
    move(rest_of_instructions, next_house, [next_house | house_path])
  end

  def get_unique_home_count(filename) do
    get_house_path(filename)
    |> Enum.uniq()
    |> Enum.count()
  end

  def get_santa_and_robot_unique_count(filename) do
    {santa_path, robot_path} =
    File.read!(filename)
    |> String.to_char_list()
    |> move_part_2({0, 0}, {0, 0}, [{0, 0}], [{0, 0}])

    combined_paths = santa_path ++ robot_path
    combined_paths
    |> Enum.uniq()
    |> Enum.count()
  end

  defp move_part_2([], _, _, santa_path, robot_path) do
    {Enum.reverse(santa_path), Enum.reverse(robot_path)}
  end
  defp move_part_2([santa_instr, robot_santa_instr | rest_of_instructions],
                    current_santa,
                    current_robot,
                    santa_path,
                    robot_path) do
    new_santa_location = move(santa_instr, current_santa)
    new_robot_location = move(robot_santa_instr, current_robot)
    move_part_2(rest_of_instructions,
                new_santa_location,
                new_robot_location,
                [new_santa_location | santa_path],
                [new_robot_location | robot_path])
  end

  defp move(?<, {x, y}), do: {x-1, y}
  defp move(?>, {x, y}), do: {x+1, y}
  defp move(?^, {x, y}), do: {x, y+1}
  defp move(?v, {x, y}), do: {x, y-1}
end

Delivery.get_house_path("delivery_instructions.txt")
|> IO.inspect()

IO.puts "Santa visited #{Delivery.get_unique_home_count("delivery_instructions.txt")} unique homes"

IO.puts "Santa and Robot Santa visited #{Delivery.get_santa_and_robot_unique_count("delivery_instructions.txt")} unique homes"