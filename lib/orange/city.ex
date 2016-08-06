defmodule Orange.City do
  use GenServer

  import Orange.Utils, only: [random_number: 2]

  alias Orange.CityExchange

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    init_state =
      CityExchange.list_exchanges
      |> Enum.map(&( {&1.city_name, &1.prefix} ))

    {:ok, init_state}
  end

  def register(city_name) do
    GenServer.call(__MODULE__, {:register, city_name})
  end

  def numbers_from(city_name) do
    GenServer.call(__MODULE__, {:list_numbers, city_name})
  end

  def find(prefix) do
    GenServer.call(__MODULE__, {:find_by_prefix, prefix})
  end

  def generate_new_number(city_name) do
    GenServer.call(__MODULE__, {:generate_new_number, city_name})
  end

  def handle_call({:list_numbers, city}, _from, state) do
    numbers =  CityExchange.get_numbers(city)
    {:reply, numbers, state}
  end

  def handle_call({:register, city}, _from, state) do
    prefix = random_number(10, 100)
    CityExchange.register_new_city(city, prefix)
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

  def terminate(error, state) do
    IO.inspect(error)
    :ok
  end
end
