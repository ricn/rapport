defmodule Rapport.Report do
  defstruct paper_size: nil,
            rotation: nil,
            title: nil,
            pages: nil,
            template: nil,
            padding: nil,
            fields: nil,
            page_number_opts: nil

  @type t :: %Rapport.Report{
          paper_size: :A4 | :A3 | :A5 | :half_letter | :letter | :legal | :junior_legal,
          rotation: :portrait | :landscape,
          title: String.t(),
          pages: list(Rapport.Page),
          template: String.t(),
          padding: non_neg_integer(),
          fields: map(),
          page_number_opts: %Rapport.PageNumbering{}
        }
end
