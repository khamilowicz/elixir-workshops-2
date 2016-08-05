defmodule Orange.City do
  import Orange.Utils, only: [random_number: 2]

  def register(city_name) do
    {:ok, random_number(10, 100)}
  end
end
