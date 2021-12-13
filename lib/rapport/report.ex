defmodule Rapport.Report do
  defstruct paper_size: nil,
            rotation: nil,
            title: nil,
            pages: nil,
            template: nil,
            padding: nil,
            fields: nil,
            page_number_opts: nil

  @type paper_size :: :A4 | :A3 | :A5 | :half_letter | :letter | :legal | :junior_legal | :ledger
  @type padding :: 10 | 15 | 20 | 25
  @type rotation :: :portrait | :landscape

  @type t :: %Rapport.Report{
          paper_size: paper_size(),
          rotation: rotation(),
          title: String.t(),
          pages: list(Rapport.Page),
          template: String.t(),
          padding: padding(),
          fields: map(),
          page_number_opts: %Rapport.PageNumbering{}
        }
end
