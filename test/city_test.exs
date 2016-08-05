defmodule Orange.CityTest do
  use ExUnit.Case
  alias Orange.City

  describe "With started City register" do
    setup(context) do
      {:ok, city_reg_pid} = City.start_link
      {:ok, Map.put(context, :pid, city_reg_pid)} 
    end

    test "City creates new city and assigns a prefix to it", %{pid: pid} do
      city_name = "Krakow"
      assert {:ok, prefix} = City.register(pid, city_name)
      assert is_number(prefix)
    end

    test "City finds city by its prefix", %{pid: pid} do
      city_name = "Krakow"
      {:ok, prefix} = City.register(pid, city_name)
      assert City.find(pid, prefix) == city_name
    end
  end

end
