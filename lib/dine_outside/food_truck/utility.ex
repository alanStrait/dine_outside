defmodule DineOutside.FoodTruck.Utility do
  @moduledoc """
  Provides support functions for shared behavior.
  """

  @doc """
  Returns a float in binary form rounded to five decimal places.

  ## Examples

      iex> parse_float(0)
      0.0

      iex> parse_float(1.1)
      1.1

      iex> parse_float("1.3")
      1.3
  """
  def parse_float(value) when is_integer(value), do: value + 0.0
  def parse_float(value) when is_float(value), do: value
  def parse_float(value) when is_binary(value) do
    value |> Float.parse() |> then(fn {f, _} -> Float.round(f, 5) end)
  end

  @doc """
  Returns an integer for float, integer, or integer represented as a string.

  ## Examples

      iex> parse_integer(1.1)
      1

      iex> parse_integer(2)
      2

      iex> parse_integer("3.3")
      3

      iex> parse_integer("4")
      4

  """
  def parse_integer(value) when is_float(value), do: round(value)
  def parse_integer(value) when is_integer(value), do: value
  def parse_integer(value) when is_binary(value) do
    {value, _} = Integer.parse(value)
    value
  end
end
