defmodule ExampleTest do
  use ExUnit.Case
  @moduletag :external

  test "hello.html" do
    page_template = "<h1><%= @hello %></h1>"

    html_report =
      Rapport.new()
      |> Rapport.add_page(page_template, %{hello: "Hello world!"})
      |> Rapport.generate_html()

    file = Path.join([File.cwd(), "examples", "hello.html"])
    File.write!(file, html_report)
  end

  test "custom_fonts_and_styles.html" do
    report_template = """
    <style>
      @font-face {
        font-family: 'Tangerine';
        font-style: normal;
        font-weight: 400;
        src: local('Tangerine Regular'), local('Tangerine-Regular'), url(<%= @font %>) format('woff2');
        unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2212, U+2215;
      }

      h1 {
        font-family: 'Tangerine', serif;
        font-size: 48px;
        text-shadow: 4px 4px 4px #aaa;
      }
    </style>
    """

    page_template = "<h1><%= @hello %></h1>"
    font = Rapport.Font.as_data(File.read!(Path.join(__DIR__, "fonts/tangerine.woff2")))

    html_report =
      Rapport.new(report_template, %{font: font})
      |> Rapport.add_page(page_template, %{hello: "Hello world!"})
      |> Rapport.generate_html()

    file = Path.join([File.cwd(), "examples", "custom_fonts_and_styles.html"])
    File.write!(file, html_report)
  end

  test "two_page_table.html" do
    report_template = File.read!(Path.join(__DIR__, "example_templates/table_report.html.eex"))
    page_template = File.read!(Path.join(__DIR__, "example_templates/table_page.html.eex"))

    all_people =
      Enum.map(1..60, fn num ->
        %{
          num: num,
          firstname: Faker.Person.first_name(),
          lastname: Faker.Person.last_name(),
          phone: Faker.Phone.EnUs.phone(),
          email: Faker.Internet.email()
        }
      end)

    number_of_people_per_page = 35
    report = Rapport.new(report_template)

    html_report =
      Enum.chunk_every(all_people, number_of_people_per_page)
      |> Enum.reduce(report, fn chunk, acc ->
        Rapport.add_page(acc, page_template, %{people: chunk})
      end)
      |> Rapport.generate_html()

    file = Path.join([File.cwd(), "examples", "two_page_table.html"])
    File.write!(file, html_report)
  end

  test "invoice.html" do
    report_template = File.read!(Path.join(__DIR__, "example_templates/invoice_report.html.eex"))
    page_template = File.read!(Path.join(__DIR__, "example_templates/invoice_page.html.eex"))
    logo = Rapport.Image.as_data(File.read!(Path.join(__DIR__, "images/acme.png")))

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
      total_price: 385,
      logo: logo
    }

    html_report =
      Rapport.new(report_template)
      |> Rapport.set_title("Invoice #1234")
      |> Rapport.add_page(page_template, invoice)
      |> Rapport.generate_html()

    file = Path.join([File.cwd(), "examples", "invoice.html"])
    File.write!(file, html_report)
  end

  test "list_of_people.html" do
    # This is a pretty advanced report that showcases how complex reports that are possible to create with
    # Rapport. The report starts with a cover page that show a summary of the rest of the report. The cover page
    # shows the city, how many people that belongs to the city and how many pages that is needed to list them.
    # The rest of the report lists all the people grouped by city and displays 12 people per page.

    report_template =
      File.read!(Path.join(__DIR__, "example_templates/list_of_people_report.html.eex"))

    cover_page_template =
      File.read!(Path.join(__DIR__, "example_templates/list_of_people_cover_page.html.eex"))

    people_page_template =
      File.read!(Path.join(__DIR__, "example_templates/list_of_people_page.html.eex"))

    top_secret_stamp_image = File.read!(Path.join(__DIR__, "images/top_secret_stamp.png"))

    cities = [
      "New York",
      "San Francisco",
      "Los Angeles",
      "Miami",
      "Chicago",
      "Boston",
      "Detroit",
      "Houston"
    ]

    top_secret_stamp = Rapport.Image.as_data(top_secret_stamp_image)

    # Generates 250 random people and sorts them by city
    all_people =
      Enum.map(1..250, fn num ->
        %{
          employee_no: 10000 + num,
          firstname: Faker.Person.first_name(),
          lastname: Faker.Person.last_name(),
          phone: Faker.Phone.EnUs.phone(),
          email: Faker.Internet.email(),
          city: Enum.at(cities, Enum.random(0..7))
        }
      end)
      |> Enum.sort(&(&1.city <= &2.city))

    people_per_page = 12

    # Creates the data for the cover page and sorts the result by city
    cover_page_data =
      Enum.map(cities, fn city ->
        num_of_employees = all_people |> Enum.filter(fn p -> p.city == city end) |> Enum.count()
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
      Enum.chunk_by(all_people, fn p -> p.city end)
      |> Enum.flat_map(fn people_per_city ->
        people_per_city
        |> Enum.chunk_every(people_per_page)
        |> Enum.map(fn people ->
          %Rapport.Page{
            template: people_page_template,
            fields: %{people: people, stamp: top_secret_stamp}
          }
        end)
      end)
      |> Enum.reverse()

    # Creates an HTML report in landscape mode
    html_report =
      Rapport.new(report_template)
      |> Rapport.set_rotation(:landscape)
      |> Rapport.add_page(cover_page_template, %{cover_page_data: cover_page_data})
      |> Rapport.add_pages(pages_with_people)
      |> Rapport.generate_html()

    file = Path.join([File.cwd(), "examples", "list_of_people.html"])
    File.write!(file, html_report)
  end

  test "page_numbering.html" do
    page_template =
      File.read!(Path.join(__DIR__, "example_templates/page_numbering_page.html.eex"))

    random_text = Enum.map_join(1..6, fn _ -> Faker.Lorem.paragraphs() end)
    fields = %{text: random_text}

    pages = Enum.map(1..4, fn _ -> %Rapport.Page{template: page_template, fields: fields} end)

    html_report =
      Rapport.new()
      |> Rapport.add_pages(pages)
      |> Rapport.add_page_numbers(:bottom_right, fn current_page, total_pages ->
        "#{current_page} of #{total_pages}"
      end)
      |> Rapport.generate_html()

    file = Path.join([File.cwd(), "examples", "page_numbering.html"])
    File.write!(file, html_report)
  end

  test "barcodes.html" do
    page_template = File.read!(Path.join(__DIR__, "example_templates/barcode_page.html.eex"))
    opts = [height: 100]
    text = "20171009213822"
    code39 = Rapport.Barcode.create(:code39, text, opts) |> Rapport.Image.as_data()
    code93 = Rapport.Barcode.create(:code93, text, opts) |> Rapport.Image.as_data()
    code128 = Rapport.Barcode.create(:code128, text, opts) |> Rapport.Image.as_data()
    itf = Rapport.Barcode.create(:itf, text, opts) |> Rapport.Image.as_data()

    html_report =
      Rapport.new()
      |> Rapport.add_page(page_template, %{
        code39: code39,
        code93: code93,
        code128: code128,
        itf: itf,
        text: text
      })
      |> Rapport.generate_html()

    file = Path.join([File.cwd(), "examples", "barcodes.html"])
    File.write!(file, html_report)
  end
end
