defmodule WhiskybaseScraper.Worker do
  use GenServer

  # Client

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def scrape(pid, whisky_id) do
    GenServer.call(pid, {:scrape, whisky_id})
  end

  # Server

  def handle_call({:scrape, whisky_id}, _from, state) do
    {:reply, WhiskybaseScraper.Client.get(whisky_id), state}
  end
end
