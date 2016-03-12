defmodule WhiskybaseScraper do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    poolboy_config = [
      {:name, {:local, pool_name()}},
      {:worker_module, WhiskybaseScraper.Worker},
      {:size, 2},
      {:max_overflow, 1}
    ]

    children = [
      :poolboy.child_spec(pool_name(), poolboy_config, [])
    ]

    options = [
      strategy: :one_for_one,
      name: WhiskybaseScraper.Supervisor
    ]

    Supervisor.start_link(children, options)
  end

  def run(whisky_ids) do
    Enum.each(
      whisky_ids,
      fn(id) -> spawn(fn() -> scrape(id) |> IO.inspect end) end
    )
  end

  def scrape(whisky_id) do
    :poolboy.transaction(
      pool_name(),
      fn(pid) -> WhiskybaseScraper.Worker.scrape(pid, whisky_id) end,
      :infinity
    )
  end

  def pool_name, do: :whiskybase_scraper_pool
end
