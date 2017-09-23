defmodule Rapport do

  @moduledoc """
  Documentation for Rapport.
  """

  @base_template File.read!(Path.join(__DIR__, "base_template.html.eex"))

  defstruct template: nil, paper_size: nil, rotation: nil, fields: nil

  def new(template_path, paper_size \\ :A4, rotation \\ :portrait) do
    {:ok, template_content} = File.read(template_path)
    %Rapport{
      template: template_content,
      paper_size: paper_size,
      rotation: rotation,
      fields: %{}}
  end

  def set_field(%Rapport{} = report, field_name, field_value) do
    fields =
      report.fields
      |> Map.put(field_name, field_value)

    Map.put(report, :fields, fields)
  end

  def generate_html(%Rapport{} = report) do
    content = EEx.eval_string report.template, assigns: report.fields
    EEx.eval_string @base_template, assigns: [content: content]
  end
end
