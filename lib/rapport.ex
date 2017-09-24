defmodule Rapport do

  @moduledoc """
  Documentation for Rapport.
  """
  @normalize_css File.read!(Path.join(__DIR__, "normalize.css"))
  @paper_css File.read!(Path.join(__DIR__, "paper.css"))
  @base_template File.read!(Path.join(__DIR__, "base_template.html.eex"))

  defstruct template: nil, paper_size: nil, rotation: nil, fields: nil, title: nil

  def new(template_path, paper_size \\ :A4, rotation \\ :portrait)
  when is_binary(template_path) and is_atom(paper_size) and is_atom(rotation) do

    validate_paper_size(paper_size)
    validate_rotation(rotation)

    {:ok, template_content} = File.read(template_path)
    %Rapport{
      template: template_content,
      paper_size: paper_size,
      rotation: rotation,
      fields: %{},
      title: "Report"}
  end

  def set_field(%Rapport{} = report, field_name, field_value) when is_binary(field_name) do
    set_field(report, String.to_atom(field_name), field_value)
  end

  def set_field(%Rapport{} = report, field_name, field_value) when is_atom(field_name) do
    fields = report.fields |> Map.put(field_name, field_value)
    Map.put(report, :fields, fields)
  end

  def set_title(%Rapport{} = report, title), do: Map.put(report, :title, title)

  def generate_html(%Rapport{} = report) do
    content = EEx.eval_string report.template, assigns: report.fields
    paper_settings = paper_settings_css(report)
    assigns = [
      content: content,
      title: report.title,
      paper_settings: paper_settings,
      normalize_css: @normalize_css,
      paper_css: @paper_css]

    EEx.eval_string @base_template, assigns: assigns
  end

  defp paper_settings_css(%Rapport{} = report) do
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
end
