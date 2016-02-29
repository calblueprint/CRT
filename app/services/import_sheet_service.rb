class ImportSheetService
  def self.create_project(file)
    xlsx = Roo::Spreadsheet.open(file)
    # The first sheet contains all the project details
    xlsx.default_sheet = xlsx.sheets[0]
    # All the project details are in the second column
    r_data = xlsx.column(2)
    # Earnings begin is always found on the 8th row
    earnings_begin = r_data[8]
    # Some excel spreadsheets are formatted such that the earnings begin is
    # in the third column not the second
    earnings_begin = xlsx.column(3)[8] unless xlsx.column(3)[8].nil?
    r = Project.create! name: r_data[0],
                        acres: r_data[1],
                        date_closed: r_data[2].to_time,
                        restricted_endowment: r_data[3],
                        cap_rate: r_data[4],
                        admin_rate: r_data[5],
                        total_upfront: r_data[6],
                        years_upfront: r_data[7],
                        earnings_begin: self.get_date_of_earnings_begin(earnings_begin)
    r.initialize_project_years_and_data_values
    r
  end

  # Date string takes on the form of "Q1 11/12" or "Q1 2011"
  def self.get_date_of_earnings_begin(date_string)
    quarter_to_month = {
      '1' => 1,
      '2' => 4,
      '3' => 7,
      '4' => 10
    }
    quarter_year = date_string.split
    quarter_string = quarter_year[0][1]
    year_string = quarter_year[1]
    year = nil
    month = quarter_to_month[quarter_string]
    if year_string.include? "/"
      years = year_string.split("/")
      year = years[0].to_i
      year = years[1].to_i if month < 6
      year += 2000
    else
      year = year_string.to_i
    end
    DateTime.new(year, month, 1)
  end
end
