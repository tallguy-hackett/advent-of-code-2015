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
end

nice_count = Nice.get_nice_count("strings.txt")
IO.puts "There are #{nice_count} nice strings"