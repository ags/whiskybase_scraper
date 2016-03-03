defmodule WhiskybaseScraper do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(WhiskybaseScraper.Worker, [[name: :sup_worker]]),
    ]

    opts = [strategy: :one_for_one, name: WhiskybaseScraper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def scrape(whisky_id) do
    WhiskybaseScraper.Worker.scrape(:sup_worker, whisky_id)
  end
end
