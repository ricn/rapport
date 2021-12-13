defmodule Rapport do
  @moduledoc """
  Rapport aims to provide a robust set of modules to generate
  HTML reports that both looks good in the browser and when being printed.
  """

  alias Rapport.Report
  alias Rapport.Page
  alias Rapport.PageNumbering

  @normalize_css File.read!(Path.join(__DIR__, "base_template/normalize.css"))
  @paper_css File.read!(Path.join(__DIR__, "base_template/paper.css"))
  @base_template File.read!(Path.join(__DIR__, "base_template/base_template.html.eex"))

  @spec add_page(Report.t(), String.t(), map) :: Report.t()
  defdelegate add_page(report, page_template, fields), to: Page
  @spec add_page(Report.t(), Page.t()) :: Report.t()
  defdelegate add_page(report, page), to: Page
  @spec add_pages(Report.t(), list(Page.t())) :: Report.t()
  defdelegate add_pages(report, pages), to: Page

  @spec generate_pages(maybe_improper_list, any) :: binary
  @spec generate_pages(maybe_improper_list, any, any) :: binary
  defdelegate generate_pages(pages, padding), to: Page
  defdelegate generate_pages(pages, padding, page_number_opts), to: Page

  @spec add_page_numbers(Report.t()) :: Report.t()
  @spec add_page_numbers(Report.t(), atom, any) :: Report.t()
  defdelegate add_page_numbers(report, page_number_position, formatter), to: PageNumbering
  @spec add_page_numbers(Report.t(), atom) :: Report.t()
  defdelegate add_page_numbers(report, page_number_position), to: PageNumbering
  defdelegate add_page_numbers(report), to: PageNumbering

  @spec new(String.t(), map()) :: Report.t()
  @doc """
  Creates a new report.

  An optional EEx template can be passed to the `new` function. This template
  is meant to hold global things like styles, fonts etc that can be used on all
  pages thats added to the report.

  The `new` function sets the default paper size to `:A4`, the rotation
  to `:portrait`, the page padding to 10mm and the report title to "Report".
  Those defaults can easily be overridden by using `set_paper_size/2`,
  `set_rotation/2`, `set_padding/2` and `set_title/2`.

  Returns a `Rapport.Report` struct.

  ## Options

    * `template` - An optional EEx template for the report.
    * `fields` - A map with fields to assign to the EEx report template
  """

  def new(template \\ "", fields \\ %{}) do
    %Report{
      title: "Report",
      paper_size: :A4,
      rotation: :portrait,
      pages: [],
      template: template,
      padding: 10,
      fields: fields,
      page_number_opts: %PageNumbering{
        add_page_numbers: false,
        page_number_position: :bottom_right,
        page_number_formatter: fn cnt_page, _tot_pages -> "#{cnt_page}" end
      }
    }
  end

  @spec set_title(Report.t(), String.t()) :: Report.t()
  @doc """
  Sets the title for a report. This is the title of the generated html report.

  ## Options

    * `report` - The `Rapport.Report` you want to set the title for.
    * `title` - The new title
  """

  def set_title(%Report{} = report, title) when is_binary(title) do
    Map.put(report, :title, title)
  end

  @spec set_paper_size(
          Report.t(),
          Report.paper_size()
        ) :: Report.t()
  @doc """
  Sets the paper size for the report.

  It expects the paper size to be an atom and must be
  `:A4`, `:A3`, `:A5`, `:half_letter`, `:letter`, `:legal`, `:junior_legal`
   or `:ledger`, otherwise `ArgumentError` will be raised.

  ## Options

    * `report` - The `Rapport.Report` that you want set the paper size for
    * `paper_size` - The paper size.
  """

  def set_paper_size(%Report{} = report, paper_size) do
    validate_list(
      paper_size,
      [:A4, :A3, :A5, :half_letter, :letter, :legal, :junior_legal, :ledger],
      "Invalid paper size"
    )

    Map.put(report, :paper_size, paper_size)
  end

  @spec set_rotation(Report.t(), Report.rotation()) :: Report.t()
  @doc """
  Sets the rotation for the report.

  It expects the rotation to an atom and must be `:portrait` or `:landscape`,
  otherwise `ArgumentError` will be raised.

  ## Options

    *  `report` - The `Rapport.Report` that you want set the rotation for
    *  `rotation` - The rotation.
  """

  def set_rotation(%Report{} = report, rotation) do
    validate_list(rotation, [:portrait, :landscape], "Invalid rotation")
    Map.put(report, :rotation, rotation)
  end

  @spec set_padding(Report.t(), Report.padding()) :: Report.t()
  @doc """
  Sets the padding (in millimeters) for the report.

  It expects the padding to be an integer and must be `10`, `15`, `20` or `25` mm,
  otherwise `ArgumentError` will be raised.

  ## Options

    * `report` - The `Rapport.Report` that you want set the padding for
    * `rotation` - The padding.
  """

  def set_padding(%Report{} = report, padding) when is_integer(padding) do
    validate_list(padding, [10, 15, 20, 25], "Invalid padding")
    Map.put(report, :padding, padding)
  end

  @spec generate_html(Report.t()) :: String.t()
  @doc """
  Generates HTML for the report.

  ## Options

    * `report` - The `Rapport.Report` that you want to generate to HTML.
  """
  def generate_html(%Report{} = report) do
    paper_settings = paper_settings_css(report)
    add_page_numbers? = report.page_number_opts.add_page_numbers

    pages =
      case add_page_numbers? do
        true -> generate_pages(report.pages, report.padding, report.page_number_opts)
        false -> generate_pages(report.pages, report.padding)
      end

    report_template = EEx.eval_string(report.template, assigns: report.fields)

    assigns = [
      title: report.title,
      paper_settings: paper_settings,
      normalize_css: @normalize_css,
      paper_css: @paper_css,
      pages: pages,
      report_template: report_template
    ]

    EEx.eval_string(@base_template, assigns: assigns)
  end

  @spec save_to_file(Report.t(), binary) :: :ok
  @doc """
  Convenient function to save a report to file.

  ## Options
    * `report` - The `Rapport.Report` that you want to save to a HTML file
    * `file_path` - The path to the HTML file you want to save.
  """
  def save_to_file(%Report{} = report, file_path) when is_binary(file_path) do
    html_report = generate_html(report)
    File.write!(file_path, html_report)
  end

  defp paper_settings_css(%Report{} = report) do
    paper_size = Atom.to_string(report.paper_size)
    rotation = Atom.to_string(report.rotation)
    if rotation == "portrait", do: paper_size, else: "#{paper_size} #{rotation}"
  end

  @spec validate_list(any, list(), String.t()) :: nil
  @doc false
  def validate_list(what, list, msg) do
    if what not in list, do: raise(ArgumentError, message: msg)
  end
end
