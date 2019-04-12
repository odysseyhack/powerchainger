defmodule EnergyTree.Shaving.Dispatcher do

  def refine(list_of_usages, prosumers) do
    aggregate = calculate_aggregate(list_of_usages)
    if should_shave?(aggregate) do
      ask_some_prosumers_to_produce(prosumers)
    else
      forward_aggregate_to_parent(aggregate)
    end
  end

  def should_shave?(aggregate) do
    # TODO
  end

  def calculate_aggregate(list_of_usages) do
    # TODO
  end

  def forward_aggregate_to_parent(aggregate) do
    # TODO
  end

  def ask_some_prosumers_to_produce(prosumers) do
  end
end
