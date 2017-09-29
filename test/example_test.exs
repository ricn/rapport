defmodule ExampleTest do
  use ExUnit.Case

  test "hello.html" do
    page_template = "<h1><%= @hello %></h1>"
    html_report =
      Rapport.new
      |> Rapport.add_page(page_template, %{hello: "Hello world!"})
      |> Rapport.generate_html

    file = Path.join([System.cwd, "examples", "hello.html"])
    File.write!(file, html_report)
  end

  test "custom fonts and styles" do
    report_template = """
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Tangerine">
    <style>
      h1 {
        font-family: 'Tangerine', serif;
        font-size: 48px;
        text-shadow: 4px 4px 4px #aaa;
      }
    </style>
    """
    page_template = "<h1><%= @hello %></h1>"
    html_report =
      Rapport.new(report_template)
      |> Rapport.add_page(page_template, %{hello: "Hello world!"})
      |> Rapport.generate_html

    file = Path.join([System.cwd, "examples", "custom_fonts_and_styles.html"])
    File.write!(file, html_report)
  end

  test "two page table" do
    report_template = Path.join(__DIR__, "templates/table_report.html.eex")
    page_template = Path.join(__DIR__, "templates/table_page.html.eex")

    all_people =
      Enum.map(1..60, fn(num) ->
        %{
          num: num,
          firstname: Faker.Name.first_name(),
          lastname: Faker.Name.last_name(),
          phone: Faker.Phone.EnUs.phone(),
          email: Faker.Internet.email()
        }
      end)
    number_of_people_per_page = 35
    report = Rapport.new(report_template)
    html_report =
      Enum.chunk_every(all_people, number_of_people_per_page)
      |> Enum.reduce(report, fn(chunk, acc) -> Rapport.add_page(acc, page_template, %{people: chunk}) end)
      |> Rapport.generate_html

    file = Path.join([System.cwd, "examples", "two_page_table.html"])
    File.write!(file, html_report)
  end

  test "invoice" do
    report_template = Path.join(__DIR__, "templates/invoice_report.html.eex")
    page_template = Path.join(__DIR__, "templates/invoice_page.html.eex")

    invoice = %{
      number: 1234,
      created_at: "2017-09-29",
      due_at: "2017-10-29",
      your_company_name: "Acme, Inc",
      your_company_address_line_1: "12345 Sunny Road",
      your_company_address_line_2: "Sunnyville, TX 12345",
      customer_name: "Customer, Inc",
      customer_address_line_1: "54321 Cloudy Road",
      customer_address_line_2: "Cloudyville, NY 54321",
      payment_method: %{method: "Check", number: 1001},
      items: [
        %{name: "Website design", price: 300},
        %{name: "Hosting (3 months)", price: 75},
        %{name: "Domain name (1 year)", price: 10}
      ],
      total_price: 385
    }

    html_report =
      Rapport.new(report_template)
      |> Rapport.set_title("Invoice #1234")
      |> Rapport.add_page(page_template, invoice)
      |> Rapport.generate_html

    file = Path.join([System.cwd, "examples", "invoice.html"])
    File.write!(file, html_report)
  end

end
