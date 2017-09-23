defmodule Rapport do

  @moduledoc """
  Documentation for Rapport.
  """
  @base_template """
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="utf-8">
    <title>A4</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/3.0.3/normalize.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/paper-css/0.2.3/paper.css">
    <style>@page { size: A4 }</style>
  </head>
  <body class="A4">
    <%= @content %>
  </body>
  </html>
  """

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
