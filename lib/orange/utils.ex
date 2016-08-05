defmodule Orange.Utils do
  def random_number(bottom, top), do: :crypto.rand_uniform(bottom, top)
end
