defmodule Nice do
  def get_nice_count(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&nice_string?/1)
    |> Enum.filter(&(&1))
    |> Enum.count()
  end

  defp nice_string?(str) do
    str
    |> contains_three_vowels?()
    |> continue_parsing_double(str)
    |> continue_parsing_naughty_substrings?(str)
  end

  defp contains_three_vowels?(str) do
    vowel_replaced_str_length = str
    |> String.replace(~r{a|e|i|o|u}, "")
    |> String.length()

    String.length(str) - vowel_replaced_str_length > 2
  end

  defp continue_parsing_double(false, _str), do: false
  defp continue_parsing_double(true, str) do
    str
    |> String.strip()
    |> contains_a_double?()
  end

  defp contains_a_double?(str) do
    str
    |> String.split("", [trim: true])
    |> double?()
  end

  defp double?([]), do: false
  defp double?([a, a | _rest]), do: true
  defp double?([_a | rest]), do: double?(rest)

  defp continue_parsing_naughty_substrings?(false, _str), do: false
  defp continue_parsing_naughty_substrings?(true, str) do
    !String.contains?(str, ["ab", "cd", "pq", "xy"])
  end

  def get_second_nice_count(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&second_nice_string?/1)
    |> Enum.filter(&(&1))
    |> Enum.count()
  end

  defp second_nice_string?(string) do
    char_list = string
    |> String.strip()
    |> String.to_char_list()

    char_list
    |> repeats_with_one_letter_between?()
    |> continue_parsing_repeating_pair?(char_list)
  end

  defp continue_parsing_repeating_pair?(false, _), do: false
  defp continue_parsing_repeating_pair?(true, string) do
    contains_repeating_pair?(string)
  end

  def repeats_with_one_letter_between?([]), do: false
  def repeats_with_one_letter_between?([a, _, a | _rest]), do: true
  def repeats_with_one_letter_between?([_ | rest]) do
    repeats_with_one_letter_between?(rest)
  end

  def contains_repeating_pair?([]), do: false
  def contains_repeating_pair?([_]), do: false
  def contains_repeating_pair?([a, b | rest]) do
    if contains_repeating_pair?(a, b, rest) do
      true
    else
      contains_repeating_pair?([b | rest])
    end
  end

  defp contains_repeating_pair?(_a, _b, []), do: false
  defp contains_repeating_pair?(a, b, [a, b | rest]), do: true
  defp contains_repeating_pair?(a, b, [_ | rest]) do
    contains_repeating_pair?(a, b, rest)
  end
end

nice_count = Nice.get_nice_count("strings.txt")
second_nice_count = Nice.get_second_nice_count("strings.txt")
IO.puts "There are #{nice_count} nice strings"
IO.puts "There are #{second_nice_count} nice strings in the second algorithm"