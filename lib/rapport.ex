defmodule Rapport do

  @moduledoc """
  Documentation for Rapport.
  """

  @base_template File.read!(Path.join(__DIR__, "base_template.html.eex"))

  defstruct template: nil, paper_size: nil, rotation: nil, fields: nil, title: nil

  def new(template_path, paper_size \\ :A4, rotation \\ :portrait) do
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
    fields =
      report.fields
      |> Map.put(field_name, field_value)

    Map.put(report, :fields, fields)
  end

  def set_title(%Rapport{} = report, title), do: Map.put(report, :title, title)

  def generate_html(%Rapport{} = report) do
    content = EEx.eval_string report.template, assigns: report.fields
    EEx.eval_string @base_template, assigns: [content: content, title: report.title]
  end
end
