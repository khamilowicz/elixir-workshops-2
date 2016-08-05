defmodule Orange.City do
  import Orange.Utils, only: [random_number: 2]

  use GenServer

  defmodule CityExchange do

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
  end

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def register(city_name) do
    GenServer.call(__MODULE__, {:register, city_name})
  end

  def find(prefix) do
    GenServer.call(__MODULE__, {:find_by_prefix, prefix})
  end

  def generate_new_number(city_name) do
    GenServer.call(__MODULE__, {:generate_new_number, city_name})
  end

  def handle_call({:register, city}, _from, state) do
    prefix = random_number(10, 100)
    {:ok, _city_exchange} = CityExchange.start_link(city)
    {:reply, {:ok, prefix}, [{city, prefix} | state]}
  end

  def handle_call({:generate_new_number, city}, _from, state) do
    new_number = CityExchange.register_number(city) |> to_string
    {_city, prefix} = find_by_city_name(city, state)
    {:reply, {:ok, "#{prefix}-#{new_number}"}, state}
  end

  def handle_call({:find_by_prefix, prefix}, _from, state) do
    {city, _prefix} = find_by_prefix(prefix, state)
    {:reply, city, state}
  end

  defp find_by_prefix(prefix, state) do
    List.keyfind(state, prefix, 1, {:not_registered, 0})
  end
  defp find_by_city_name(city, state) do
    List.keyfind(state, city, 0, {:not_registered, 0})
  end
end
