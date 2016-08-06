defmodule Orange.CityExchangeSup do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    import Supervisor.Spec, warn: false

    children = [
      # Starts a worker by calling: Orange.Worker.start_link(arg1, arg2, arg3)
      worker(Orange.CityExchange, [], restart: :transient),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :simple_one_for_one]
    supervise(children, opts)
  end
end
