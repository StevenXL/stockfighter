defmodule Stockfighter do
  def main(args) do
    args |> parse_args |> process
  end

  def api_base_url do
    "https://api.stockfighter.io/ob/api"
  end

  def api_key do
    System.get_env("STOCKFIGHTER_API_KEY")
  end

  def calculate_midpoint(venue, stock) do
    case HTTPoison.get("#{api_base_url}/venues/#{venue}/stocks/#{stock}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts body

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def current_market_midpoint_price(venue, stock) do
    calculate_midpoint(venue, stock)
  end

  def fulfill_block_trade(info) do
    current_market_midpoint_price(Keyword.get(info, :venue), Keyword.get(info, :stock))
  end

  def headers do
    [{"X-Starfighter-Authorization", api_key}]
  end

  defp parse_args(args) do
    case OptionParser.parse(args, switches: [account: :string, venue: :string, stock: :string]) do
     {options, _, []} ->
       options

     {_, _, unknown} ->
       IO.puts "Unknown options passed"
       Enum.each(unknown, fn ({key, value}) ->
         IO.puts "#{key}: #{value}"
       end)
     end
  end

  def process([]) do
    IO.puts "No options passed in!"
  end

  def process(args) do
    fulfill_block_trade(args)
  end
end
