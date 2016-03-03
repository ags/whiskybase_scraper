defmodule WhiskybaseScraper.Client do
  def get(id) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = get_page(id)

    attrs = body
      |> Floki.find("#whisky-info tr")
      |> Enum.map(&node_pair/1)
      |> Enum.into(%{})

    whisky = %WhiskybaseScraper.Whisky{
      age: attrs["Age"],
      bottler: attrs["Bottler"],
      bottling_serie: attrs["Bottling serie"],
      brand_name: text_from_selector(body, ".whisky-brandname"),
      casktype: attrs["Casktype"],
      distillery: attrs["Distillery"],
      district: attrs["District"],
      image_url: image_src(body),
      name: text_from_selector(body, ".whisky-name"),
      size: attrs["Size"],
      strength: attrs["Strength"],
    }

    {:ok, whisky}
  end

  defp node_pair(node) do
    node
      |> Floki.find("td")
      |> Enum.map(&Floki.text/1)
      |> List.to_tuple
  end

  defp image_src(node) do
    node
      |> Floki.find("#whisky-photo-open")
      |> Floki.attribute("src")
      |> List.first
  end

  defp text_from_selector(node, selector) do
    node |> Floki.find(selector) |> Floki.text
  end

  defp get_page(whisky_id) do
    HTTPoison.get("https://www.whiskybase.com/whisky/#{whisky_id}")
  end
end
