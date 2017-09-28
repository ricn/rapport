defmodule Rapport do

  @moduledoc """
  Documentation for Rapport.
  """

  alias Rapport.Report
  alias Rapport.Page

  @normalize_css File.read!(Path.join(__DIR__, "normalize.css"))
  @paper_css File.read!(Path.join(__DIR__, "paper.css"))
  @base_template File.read!(Path.join(__DIR__, "base_template.html.eex"))

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

  def add_page(%Report{} = report, page_template, %{} = fields) do
    template = template_content(page_template)
    new_page = %Page{template: template, fields: fields}
    Map.put(report, :pages, [new_page | report.pages])
  end

  def set_title(%Report{} = report, title) when is_binary(title) do
    Map.put(report, :title, title)
  end

  def set_paper_size(%Report{} = report, paper_size) do
    validate_list(paper_size,
    [:A4, :A3, :A5, :half_letter, :letter,
    :legal, :junior_legal, :ledger], "Invalid paper size")
    Map.put(report, :paper_size, paper_size)
  end

  def set_rotation(%Report{} = report, rotation) do
    validate_list(rotation, [:portrait, :landscape], "Invalid rotation")
    Map.put(report, :rotation, rotation)
  end

  def set_padding(%Report{} = report, padding) do
    validate_list(padding, [10, 15, 20, 25], "Invalid padding")
    Map.put(report, :padding, padding)
  end

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
