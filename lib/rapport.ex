defmodule Rapport do

  @moduledoc """
  Documentation for Rapport.
  """

  alias Rapport.Report
  alias Rapport.Page

  @normalize_css File.read!(Path.join(__DIR__, "normalize.css"))
  @paper_css File.read!(Path.join(__DIR__, "paper.css"))
  @base_template File.read!(Path.join(__DIR__, "base_template.html.eex"))

  def new(template \\ nil), do: %Report{ title: "Report", paper_size: :A4, rotation: :portrait, pages: []}

  def add_page(%Report{} = report, page_template, %{} = fields) do
    template = template_content(page_template)
    new_page = %Page{template: template, fields: fields}
    Map.put(report, :pages, [new_page | report.pages])
  end

  def set_title(%Report{} = report, title) when is_binary(title) do
    Map.put(report, :title, title)
  end

  def set_paper_size(%Report{} = report, paper_size) do
    validate_paper_size(paper_size)
    Map.put(report, :paper_size, paper_size)
  end

  def set_rotation(%Report{} = report, rotation) do
    validate_rotation(rotation)
    Map.put(report, :rotation, rotation)
  end

  def generate_html(%Report{} = report) do
    paper_settings = paper_settings_css(report)
    pages = generate_pages(report.pages)

    assigns = [
      title: report.title,
      paper_settings: paper_settings,
      normalize_css: @normalize_css,
      paper_css: @paper_css,
      pages: pages
    ]

    EEx.eval_string @base_template, assigns: assigns
  end

  defp generate_pages(pages) when is_list(pages) do
    Enum.reverse(pages)
    |> Enum.map(fn(page) -> generate_page(page) end)
    |> Enum.join
  end

  defp generate_page(p), do: EEx.eval_string p.template, assigns: p.fields

  defp paper_settings_css(%Report{} = report) do
    paper_size = Atom.to_string(report.paper_size)
    rotation = Atom.to_string(report.rotation)
    if rotation == "portrait", do: paper_size, else: "#{paper_size} #{rotation}"
  end

  defp validate_paper_size(paper_size) do
    allowed_paper_sizes = [:A4, :A3, :A5, :half_letter, :letter, :legal, :junior_legal, :ledger]
    msg = "Invalid paper size"
    if paper_size not in allowed_paper_sizes, do: raise ArgumentError, message: msg
  end

  defp validate_rotation(rotation) do
    allowed_rotations = [:portrait, :landscape]
    msg = "Invalid rotation"
    if rotation not in allowed_rotations, do: raise ArgumentError, message: msg
  end

  defp template_content(template) do
    if (File.exists?(template)), do: File.read!(template), else: template
  end
end
