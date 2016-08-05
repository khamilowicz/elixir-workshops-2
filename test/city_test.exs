defmodule Orange.CityTest do

  use ExUnit.Case
  alias Orange.City

  test "City creates new city and assigns a prefix to it" do
    city_name = "Krakow"
    assert {:ok, prefix} = City.register(city_name)
    assert is_number(prefix)
  end

end
