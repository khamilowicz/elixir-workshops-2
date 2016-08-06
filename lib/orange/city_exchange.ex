defmodule Orange.CityExchange do
  import Orange.Utils, only: [random_number: 2]

  def register_new_city(city_name) do
    Supervisor.start_child(Orange.CityExchangeSup, [city_name])
  end

  def start_link(city_name) do
    Agent.start_link(fn -> %{} end, name: {:global, city_name})
  end

  def register_number(city_name) do
    new_number = random_number(1000, 10000)
    Agent.update {:global, city_name}, fn(numbers) ->
      Map.put(numbers, new_number, nil)
    end
    new_number
  end

  def get_numbers(city_name) do
    Agent.get({:global, city_name}, &Map.keys/1)
  end
end

