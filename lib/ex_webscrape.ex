defmodule WebScrape do

  def main(_argv) do
    pages = 1..142
    result = Enum.reduce(pages, 0, fn(x, acc) -> count_pictures_on_page(x) + acc end)
    IO.puts "Result is: #{result}"
  end

  defp count_pictures_on_page(n) do
    {:ok, result} = download_page(n)
    {:ok, picture_count} = count_pictures(result)
    picture_count 
  end

  defp download_page(n) do
    IO.puts "get page #{n}"
    response = HTTPotion.get "https://scholarsphere.psu.edu/users?page=#{n}"
    {:ok, response.body}
  end

  defp count_pictures(html) do
    nodes = Floki.find(html, "#Data img") |> Floki.attribute("src")
    customized = Enum.filter(nodes, fn(element) -> String.starts_with?(element, "/system/avatars") end)
    IO.puts inspect customized
    {:ok, length customized }
  end
end
