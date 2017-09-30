defmodule Rapport do

  @moduledoc """
  Rapport aims to provide a robust set of modules to generate
  HTML reports that both looks good in the browser and when being printed.
  """

  alias Rapport.Report
  alias Rapport.Page

  @normalize_css File.read!(Path.join(__DIR__, "normalize.css"))
  @paper_css File.read!(Path.join(__DIR__, "paper.css"))
  @base_template File.read!(Path.join(__DIR__, "base_template.html.eex"))

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

    * `:template` - An optional EEx template for the report.
  """

  def new(template \\ "") do
    report_template = template_content(template)
    %Report{
      title: "Report",
      paper_size: :A4,
      rotation: :portrait,
      pages: [],
      template: report_template,
      padding: 10
    }
  end

  @doc """
  Adds a new page to a report.

  ## Options

    * `:report` - A `Rapport.Report` struct that you want to add the page to.
    * `:page_template` - An EEx template for the page
    * `:fields` - A map with fields that must be assigned to the EEx template
  """

  def add_page(%Report{} = report, page_template, %{} = fields) do
    template = template_content(page_template)
    new_page = %Page{template: template, fields: fields}
    Map.put(report, :pages, [new_page | report.pages])
  end

  # TODO: Add docs n tests
  def add_page(%Report{} = report, %Page{} = page) do
    Map.put(report, :pages, [page | report.pages])
  end

  # TODO: Add docs n tests
  def add_pages(%Report{} = report, pages) do
    Map.put(report, :pages, pages ++ report.pages)    
  end

  @doc """
  Sets the title for a report. This is the title of the generated html report.

  ## Options

    * `:report` - The `Rapport.Report` you want to set the title for.
    * `:title` - The new title
  """

  def set_title(%Report{} = report, title) when is_binary(title) do
    Map.put(report, :title, title)
  end

  @doc """
  Sets the paper size for the report.

  It expects the paper size to be an atom and must be
  `:A4`, `:A3`, `:A5`, `:half_letter`, `:letter`, `:legal`, `:junior_legal`
   or `:ledger`, otherwise `ArgumentError` will be raised.

  ## Options

    * `:report` - The `Rapport.Report` that you want set the paper size for
    * `:paper_size` - The paper size.
  """

  def set_paper_size(%Report{} = report, paper_size) do
    validate_list(paper_size,
    [:A4, :A3, :A5, :half_letter, :letter,
    :legal, :junior_legal, :ledger], "Invalid paper size")
    Map.put(report, :paper_size, paper_size)
  end

  @doc """
  Sets the rotation for the report.

  It expects the rotation to an atom and must be `:portrait` or `:landscape`,
  otherwise `ArgumentError` will be raised.

  ## Options

    *  `:report` - The `Rapport.Report` that you want set the rotation for
    *  `:rotation` - The rotation.
  """

  def set_rotation(%Report{} = report, rotation) do
    validate_list(rotation, [:portrait, :landscape], "Invalid rotation")
    Map.put(report, :rotation, rotation)
  end

  @doc """
  Sets the padding (in millimeters) for the report.

  It expects the padding to be an integer and must be `10`, `15`, `20` or `25` mm,
  otherwise `ArgumentError` will be raised.

  ## Options

    * `:report` - The `Rapport.Report` that you want set the padding for
    * `:rotation` - The padding.
  """

  def set_padding(%Report{} = report, padding) when is_integer(padding) do
    validate_list(padding, [10, 15, 20, 25], "Invalid padding")
    Map.put(report, :padding, padding)
  end

  @doc """
  Generates HTML for the report.

  ## Options

    * `:report` - The `Rapport.Report` that you want to generate to HTML.
  """

  def generate_html(%Report{} = report) do
    paper_settings = paper_settings_css(report)
    pages = generate_pages(report.pages, report.padding)

    assigns = [
      title: report.title,
      paper_settings: paper_settings,
      normalize_css: @normalize_css,
      paper_css: @paper_css,
      pages: pages,
      report_template: report.template
    ]

    EEx.eval_string @base_template, assigns: assigns
  end

  #########################
  ### Private functions ###
  #########################

  defp generate_pages(pages, padding) when is_list(pages) do
    Enum.reverse(pages)
    |> Enum.map(fn(page) -> generate_page(page, padding) end)
    |> Enum.join
  end

  defp generate_page(p, padding) do
    EEx.eval_string wrap_page_with_padding(p.template, padding), assigns: p.fields
  end

  defp wrap_page_with_padding(template, padding) do
    padding_css = "padding-" <> Integer.to_string(padding) <> "mm"
    """
    <div class=\"sheet #{padding_css}\">
      #{template}
    </div>
    """
  end

  defp paper_settings_css(%Report{} = report) do
    paper_size = Atom.to_string(report.paper_size)
    rotation = Atom.to_string(report.rotation)
    if rotation == "portrait", do: paper_size, else: "#{paper_size} #{rotation}"
  end

  defp validate_list(what, list, msg) do
    if what not in list, do: raise ArgumentError, message: msg
  end

  defp template_content(template) do
    if (File.exists?(template)), do: File.read!(template), else: template
  end
end
