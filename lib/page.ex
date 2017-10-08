defmodule Rapport.Page do
  defstruct template: nil, fields: nil

  alias Rapport.Report
  alias Rapport.Page

  @doc """
  Adds a new page to a report.

  ## Options

    * `report` - A `Rapport.Report` struct that you want to add the page to.
    * `page_template` - An EEx template for the page
    * `fields` - A map with fields that must be assigned to the EEx template
  """

  def add_page(%Report{} = report, page_template, %{} = fields) when is_binary(page_template) do
    new_page = %Page{template: page_template, fields: fields}
    Map.put(report, :pages, [new_page | report.pages])
  end

  @doc """
  Adds a new page to a report.

  ## Options

    * `report` - A `Rapport.Report` struct that you want to add the page to.
    * `page` - A `Rapport.Page` struct
  """
  def add_page(%Report{} = report, %Page{} = page) do
    Map.put(report, :pages, [page | report.pages])
  end

  @doc """
  Adds a list of pages to a report.

  ## Options
    * `report` - A `Rapport.Report` struct that you want to add the page to.
    * `pages` - A list with `Rapport.Page` structs
  """
  def add_pages(%Report{} = report, pages) when is_list(pages) do
    Map.put(report, :pages, pages ++ report.pages)
  end

  @doc false
  def generate_pages(pages, padding) when is_list(pages) do
    Enum.reverse(pages)
    |> Enum.map(fn(page) -> generate_page(page, padding) end)
    |> Enum.join
  end

  @doc false
  def generate_pages(pages, padding, page_number_position, page_number_formatter) when is_list(pages) do
    total_pages = Enum.count(pages)
    Enum.reverse(pages)
    |> Enum.with_index
    |> Enum.map(fn({page, index}) -> generate_page(page, padding, index + 1, total_pages, page_number_position, page_number_formatter) end)
    |> Enum.join
  end

  @doc false
  def generate_page(p, padding) do
    EEx.eval_string wrap_page_with_padding(p.template, padding), assigns: p.fields
  end

  @doc false
  def generate_page(p, padding, page_number, total_pages, page_number_position, page_number_formatter) do
    EEx.eval_string wrap_page_with_padding(p.template, padding, page_number, total_pages, page_number_position, page_number_formatter), assigns: p.fields
  end

  @doc false
  def wrap_page_with_padding(template, padding) do
    padding_css = "padding-" <> Integer.to_string(padding) <> "mm"
    """
    <div class=\"sheet #{padding_css}\">
      #{template}
    </div>
    """
  end

  @doc false
  def wrap_page_with_padding(template, padding, page_number, total_pages, page_number_position, page_number_formatter) do
    padding_css = "padding-" <> Integer.to_string(padding) <> "mm"
    position = Atom.to_string(page_number_position)
    page_number_tag = "<span class='page-numbering #{position}'>#{page_number_formatter.(page_number, total_pages)}</span>"
    """
    <div class=\"sheet #{padding_css}\">
      #{template}
      #{page_number_tag}
    </div>
    """
  end

end
