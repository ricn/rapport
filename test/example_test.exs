defmodule ExampleTest do
  use ExUnit.Case
  @moduletag :external

  test "hello.html" do
    page_template = "<h1><%= @hello %></h1>"
    html_report =
      Rapport.new
      |> Rapport.add_page(page_template, %{hello: "Hello world!"})
      |> Rapport.generate_html

    file = Path.join([System.cwd, "examples", "hello.html"])
    File.write!(file, html_report)
  end

  test "custom_fonts_and_styles.html" do
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

  test "two_page_table.html" do
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

  test "invoice.html" do
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
      customer_address_line_2: "Cloudlyville, NY 54321",
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

  test "list_of_people.html" do
    report_template = Path.join(__DIR__, "templates/list_of_people_report.html.eex")
    cover_page_template = Path.join(__DIR__, "templates/list_of_people_cover_page.html.eex")
    people_page_template = Path.join(__DIR__, "templates/list_of_people_page.html.eex")

    eight_cities = ["New York", "San Francisco", "Los Angeles", "Miami", "Chicago", "Boston", "Detroit", "Houston"]

    all_people =
      Enum.map(1..500, fn(num) ->
        %{
          employee_no: 10000 + num,
          firstname: Faker.Name.first_name(),
          lastname: Faker.Name.last_name(),
          phone: Faker.Phone.EnUs.phone(),
          email: Faker.Internet.email(),
          city: Enum.at(eight_cities, Enum.random(0..7))
        }
      end)

    employees_per_page = 20

    cover_page_data =
      Enum.map(eight_cities, fn(city) ->
        num_of_employees = count_num_of_employees_for_city(all_people, city)
        num_of_pages = round(Float.ceil(num_of_employees / employees_per_page))
        %{
          city: city,
          num_of_employees: num_of_employees,
          num_of_pages: num_of_pages
        }
      end)

    html_report =
      Rapport.new(report_template)
      |> Rapport.set_rotation(:landscape)
      |> Rapport.add_page(cover_page_template, %{cover_page_data: cover_page_data})
      |> Rapport.add_page(people_page_template, %{})
      |> Rapport.generate_html

    file = Path.join([System.cwd, "examples", "list_of_people.html"])
    File.write!(file, html_report)

    # Cover page with index
    # Page numbering per city
    # Image in header
    # Landscape
    # Group by City
    # People
    # Faker.Address.city
  end

  defp count_num_of_employees_for_city(all_people, city) do
    all_people |> Enum.filter(fn(p) -> p.city == city end) |> Enum.count
  end

end
