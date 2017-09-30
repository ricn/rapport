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
    # This is a pretty advanced report that showcases how complex reports that are possible to create with
    # Rapport. The report starts with a cover page that show a summary of the rest of the report. The cover page
    # shows the city, how many people that belongs to the city and how many pages that is needed to list them.
    # The rest of the report lists all the people grouped by city and displays 12 people per page.

    report_template = File.read!(Path.join(__DIR__, "templates/list_of_people_report.html.eex"))
    cover_page_template = File.read!(Path.join(__DIR__, "templates/list_of_people_cover_page.html.eex"))
    people_page_template = File.read!(Path.join(__DIR__, "templates/list_of_people_page.html.eex"))

    cities = ["New York", "San Francisco", "Los Angeles", "Miami", "Chicago", "Boston", "Detroit", "Houston"]

    # Generates 500 random people and sorts them by city
    all_people =
      Enum.map(1..500, fn(num) ->
        %{
          employee_no: 10000 + num,
          firstname: Faker.Name.first_name(),
          lastname: Faker.Name.last_name(),
          phone: Faker.Phone.EnUs.phone(),
          email: Faker.Internet.email(),
          city: Enum.at(cities, Enum.random(0..7))
        }
      end)
      |> Enum.sort(&(&1.city <= &2.city))

    people_per_page = 12

    # Creates the data for the cover page and sorts the result by city
    cover_page_data =
      Enum.map(cities, fn(city) ->
        num_of_employees = all_people |> Enum.filter(fn(p) -> p.city == city end) |> Enum.count
        num_of_pages = round(Float.ceil(num_of_employees / people_per_page))
        %{
          city: city,
          num_of_employees: num_of_employees,
          num_of_pages: num_of_pages
        }
      end)
      |> Enum.sort(&(&1.city <= &2.city))

    # Creates pages with all people that is chunked by city and all the people per city
    # is chunked every time we have 12 people
    pages_with_people =
      Enum.chunk_by(all_people, fn(p) -> p.city end)
      |> Enum.flat_map(fn(people_per_city) ->
        people_per_city
        |> Enum.chunk_every(people_per_page)
        |> Enum.map(fn(people) ->
          %Rapport.Page{template: people_page_template, fields: %{people: people}}
        end)
      end)
      |> Enum.reverse

      # Creates an HTML report in landscape mode
      html_report =
        Rapport.new(report_template)
        |> Rapport.set_rotation(:landscape)
        |> Rapport.add_page(cover_page_template, %{cover_page_data: cover_page_data})
        |> Rapport.add_pages(pages_with_people)
        |> Rapport.generate_html

    file = Path.join([System.cwd, "examples", "list_of_people.html"])
    File.write!(file, html_report)
  end
end