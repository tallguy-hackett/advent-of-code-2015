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
end

Delivery.get_house_path("delivery_instructions.txt")
|> IO.inspect()

IO.puts "Santa visited #{Delivery.get_unique_home_count("delivery_instructions.txt")} unique homes"