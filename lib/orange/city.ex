defmodule Orange.City do
  import Orange.Utils, only: [random_number: 2]

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def register(city_name) do
    GenServer.call(__MODULE__, {:register, city_name})
  end

  def find(prefix) do
    GenServer.call(__MODULE__, {:find_by_prefix, prefix})
  end

  def handle_call({:register, city}, _from, state) do
    prefix = random_number(10, 100)
    {:reply, {:ok, prefix}, [{city, prefix} | state]}
  end

  def handle_call({:find_by_prefix, prefix}, _from, state) do
    {city, _prefix} = List.keyfind(state, prefix, 1, {:not_registered, 0})
    {:reply, city, state}
  end

end
