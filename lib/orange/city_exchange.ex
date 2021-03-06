defmodule Orange.CityExchange do
  import Orange.Utils, only: [random_number: 2]

  def list_exchanges do
    Orange.CityExchangeSup
    |> Supervisor.which_children
    |> Enum.map(fn({_, pid, _, _}) ->
      __MODULE__.get_meta(pid)
    end)
  end
  def list_exchanges(from) do
    send from, list_exchanges
  end

  def register_new_city(city_name, prefix) do
    Supervisor.start_child(Orange.CityExchangeSup, [city_name, prefix])
  end

  def start_link(city_name, prefix) do
    Agent.start_link(fn -> {%{prefix: prefix, city_name: city_name}, %{}} end, name: {:global, city_name})
  end

  def register_number(city_name) do
    new_number = random_number(1000, 10000)
    Agent.update {:global, city_name}, fn({prefix, numbers}) ->
      {prefix, Map.put(numbers, new_number, nil)}
    end
    new_number
  end

  def get_meta(pid) do
    Agent.get(pid, fn({meta, _}) -> meta end)
  end

  def get_numbers(city_name) do
    Agent.get({:global, city_name}, fn({_, numbers}) -> Map.keys(numbers) end)
  end
end

