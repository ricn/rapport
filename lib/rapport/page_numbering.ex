defmodule Rapport.PageNumbering do
  defstruct add_page_numbers: nil, page_number_position: nil, page_number_formatter: nil

  @type t :: %Rapport.PageNumbering{
          add_page_numbers: boolean(),
          page_number_position: :bottom_right | :bottom_left | :top_right | :top_left,
          page_number_formatter: function()
        }

  alias Rapport.Report

  @doc """
  Adds page numbers to the pages

  It expects the page position to be an atom and must be `:bottom_right`, `:bottom_left`, `:top_right` or `:top_left`,
  otherwise `ArgumentError` will be raised.

  ## Options

    * `report` - The `Rapport.Report` that you want set the padding for
    * `page_number_position` - Where the page number will be positioned.
  """
  def add_page_numbers(
        %Report{} = report,
        page_number_position \\ :bottom_right,
        formatter \\ fn cnt_page, _ -> "#{cnt_page}" end
      )
      when is_atom(page_number_position) do
    Rapport.validate_list(
      page_number_position,
      [:bottom_right, :bottom_left, :top_right, :top_left],
      "Invalid page number position"
    )

    opts =
      report.page_number_opts
      |> Map.put(:add_page_numbers, true)
      |> Map.put(:page_number_position, page_number_position)
      |> Map.put(:page_number_formatter, formatter)

    Map.put(report, :page_number_opts, opts)
  end
end
