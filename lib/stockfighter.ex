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

  def calculate_high_bid(bids) do
    Enum.map(bids, fn(bid) -> Map.get(bid, "price") end) |> Enum.max
  end

  def calculate_low_offer(asks) do
    Enum.map(asks, fn(asks) -> Map.get(asks, "price") end) |> Enum.min
  end

  def calculate_midpoint_price(order_book) do
    high_bid = Map.get(order_book, "bids") |> calculate_high_bid
    low_ask = Map.get(order_book, "asks") |> calculate_low_offer

    midpoint = (high_bid + low_ask) / 2 |> round
    IO.puts "MidPoint of Market Calculated: #{midpoint}"
    midpoint
  end

  def current_order_book(venue, stock) do
    case HTTPoison.get("#{api_base_url}/venues/#{venue}/stocks/#{stock}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode!(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def current_market_midpoint_price(venue, stock) do
    current_order_book(venue, stock) |> calculate_midpoint_price
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
