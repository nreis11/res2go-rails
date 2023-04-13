module DataHelper
  def self.get_page(url)
    HTTParty.get(url)
  end

  def self.convert_to_noko(url)
    Nokogiri::HTML(self.get_page(url))
  end

  def self.extract_table_data(document)
    table_data_children = [1, 3, 5]
    main_content = document.css('#RES')
    table_rows = main_content.css('.white')

    rows = []
    table_rows.each do |row|
      table_data = table_data_children.map do |child_index|
        data_point = row.css("td:nth-child(#{child_index})").text
        data_point.strip
      end
      rows << table_data
    end
    rows
  end

  def self.clean_up_data(rows)
    rows.delete_if { |row| row.any? { |value| value.length < 3 } }
    rows
  end

  # Write to file
  def self.csv_writer(rows)
    headers = ["name", "capacity", "storage"]
    CSV.open("reservoir_data.csv", 'w') do |csv|
      csv << headers
      rows.each do |row|
        csv << row
      end
    end
  end

  # Open csv
  def self.parse_csv(filename)
    reservoir_hashes = []
    CSV.foreach(filename, headers:true, :header_converters => :symbol) do |row|
      row[:capacity] = row[:capacity].delete(',').to_i
      row[:storage] = row[:storage].delete(',').to_i
      reservoir_hashes << row.to_hash
    end
    reservoir_hashes
  end

  def self.generate_hashes(url)
    noko_doc = convert_to_noko(url)
    rows = extract_table_data(noko_doc)
    sanitized_rows = clean_up_data(rows)
    csv_writer(sanitized_rows)
    reservoir_hashes = parse_csv("reservoir_data.csv")
  end

end

# result = DataHelper.generate_hashes(RESERVOIR_PAGE)

# Pry.start(binding)


