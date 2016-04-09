defmodule Stockfighter do
  def main(args) do
    args |> parse_args |> process
  end

  def fulfill_block_trade(_info) do
  end

  defp parse_args(args) do
    case OptionParser.parse(args, switches: [account: :string, venue: :string, stock: :string, qty: :integer]) do
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
