defmodule Orange.CityTest do
  use ExUnit.Case
  alias Orange.City

  describe "With started City register" do
    setup [:start_city_server]

    test "City creates new city and assigns a prefix to it" do
      city_name = "Krakow"
      assert {:ok, prefix} = City.register(city_name)
      assert is_number(prefix)
    end
  end

  describe "With registered city" do
    setup [:start_city_server, :register_city]

    test "City finds city by its prefix", %{city_name: city_name, prefix: prefix} do
      assert City.find(prefix) == city_name
    end

    test "City registers new number", %{city_name: city_name, prefix: prefix} do
      {:ok, number} = City.generate_new_number(city_name)
      assert String.starts_with?(number, to_string(prefix))
    end
  end

  def register_city(context) do
    city_name = "Krakow"
    {:ok, prefix} = City.register(city_name)
    {:ok, Map.merge(context, %{city_name: city_name, prefix: prefix})}
  end

  def start_city_server(context) do
    {:ok, _city_reg_pid} = City.start_link
    {:ok, context}
  end

end
