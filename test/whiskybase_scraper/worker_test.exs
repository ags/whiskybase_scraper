defmodule WhiskybaseScraper.WorkerTest do
  use ExUnit.Case, async: true

  setup do
    HTTPoison.start
    {:ok, worker} = WhiskybaseScraper.Worker.start_link
    {:ok, worker: worker}
  end

  test "scrapes whisky details", %{worker: worker} do
    {:ok, whisky} = WhiskybaseScraper.Worker.scrape(worker, 115)

    IO.inspect whisky

    assert whisky.brand_name == "Macallan"
    assert whisky.age == "12 years old"
  end
end
