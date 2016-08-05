defmodule Orange.CityTest do
  use ExUnit.Case
  alias Orange.City

  describe "With started City register" do
    setup [:start_city_server]

    test "City creates new city and assigns a prefix to it", %{pid: pid} do
      city_name = "Krakow"
      assert {:ok, prefix} = City.register(pid, city_name)
      assert is_number(prefix)
    end
  end

  describe "With registered city" do
    setup [:start_city_server, :register_city]

    test "City finds city by its prefix", %{pid: pid, city_name: city_name, prefix: prefix} do
      assert City.find(pid, prefix) == city_name
    end

    test "City registers new number", %{pid: pid, city_name: city_name, prefix: prefix} do
    end
  end

  def register_city(context) do
    city_name = "Krakow"
    {:ok, prefix} = City.register(context.pid, city_name)
    {:ok, Map.merge(context, %{city_name: city_name, prefix: prefix})}
  end

  def start_city_server(context) do
    {:ok, city_reg_pid} = City.start_link
    {:ok, Map.put(context, :pid, city_reg_pid)}
  end

end
