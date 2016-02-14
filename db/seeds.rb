# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Excel spreadsheets are organized where the first sheet contains all the
# project details, and the second sheet contains all the data values where the
# columns are the years, and the rows are the data types

def production_db
  @files = Dir.glob("./data/*.xlsx")
  @files.each do |file|
    xlsx = Roo::Spreadsheet.open(file)
    # The first sheet contains all the project details
    xlsx.default_sheet = xlsx.sheets[0]
    # All the project details are in the second column
    r_data = xlsx.column(2)
    # Earnings begin is always found on the 8th row
    earnings_begin = r_data[8]
    # Some excel spreadsheets are formatted such that the earnings begin is
    # in the third column not the second
    if xlsx.column(3)[8] != nil
      earnings_begin = xlsx.column(3)[8]
    end
    r = Project.create! name: r_data[0],
                       acres: r_data[1],
                 date_closed: r_data[2].to_time,
        restricted_endowment: r_data[3],
                    cap_rate: r_data[4],
                  admin_rate: r_data[5],
               total_upfront: r_data[6],
               years_upfront: r_data[7],
              earnings_begin: get_date_of_earnings_begin(earnings_begin)
    # The second sheet, always called "Summary" with all the data.
    ranch_summary = xlsx.sheet('Summary')
    # The first column has all the data types
    data_types = ranch_summary.column(1)
    (2..ranch_summary.last_column).each do |n|
      # Each subsequent column starts with a year as the first element.
      year_col = ranch_summary.column(n)
      start_date = get_date_from_year_header(year_col[0])
      # And the rest of the column has the data values pertaining to the
      # relevant year and data type.
      y = Year.find_or_create_by(year: start_date)
      curr_year = ProjectYear.create! date: start_date, project_id: r.id, year: y
      (0..year_col.count).each do |i|
        # There could be nil values in data_types
        if data_types[i]
          curr_data_type = DataType.find_by name: data_types[i]
          # Creates the data type if it does not exist yet
          if !curr_data_type
            puts data_types[i]
            curr_data_type = Data.find_or_create_by! name: data_types[i]
          end
          DataValue.create! value: ranch_summary.column(n)[i],
                          project_year_id: curr_year.id,
                     data_type_id: curr_data_type.id
        end
      end
    end
  end
end

# Date string takes on the form of "Q1 11/12" or "Q1 2011"
def get_date_of_earnings_begin(date_string)
  quarter_to_month = {
    '1' => 1,
    '2' => 4,
    '3' => 7,
    '4' => 10,
  }
  quarter_year = date_string.split()
  quarter_string = quarter_year[0][1]
  year_string = quarter_year[1]
  year = nil
  month = quarter_to_month[quarter_string]
  if year_string.include? "/"
    years = year_string.split("/")
    year = years[0].to_i
    if month < 6
      year = years[1].to_i
    end
    year += 2000
  else
    year = year_string.to_i
  end
  return DateTime.new(year, month, 1)
end

# Parses the sheet header which specifies what year these data points pertain
# to. Headers come in the form of "11--12", "2011", or "7/11 -7/12"
def get_date_from_year_header(date_string)
  month = 1
  year = nil
  if date_string.is_a? Float
    year = date_string.to_i
  elsif date_string.include? "/"
    date_string = date_string.split(" -")[0]
    month = date_string.split("/")[0].to_i
    year = date_string.split("/")[1].to_i
    year += 2000
  elsif date_string.include? "--"
    month = 7
    year = date_string.split("--")[0].to_i
    year += 2000
  end
  return DateTime.new(year, month, 1)
end

def development
  user = User.new email: 'admin@admin.com', password: 'password', password_confirmation: 'password'
  user.save validate: false
  f1 = DataType.find_or_create_by! name: 'Q1 Earnings', order: 1
  f2 = DataType.find_or_create_by! name: 'Q2 Earnings', order: 2
  f3 = DataType.find_or_create_by! name: 'Q3 Earnings', order: 3
  f4 = DataType.find_or_create_by! name: 'Q4 Earnings', order: 4
  f5 = DataType.find_or_create_by! name: 'Earnings', formula: 'Q1_Earnings + Q2_Earnings + Q3_Earnings + Q4_Earnings', order: 5
  f6 = DataType.find_or_create_by! name: 'Q3 times Q4', formula: 'Q3_Earnings * Q4_Earnings', order: 6
  f7 = DataType.find_or_create_by! name: 'Q4 plus 10', formula: 'Q4_Earnings + 10', order: 7
  f8 = DataType.find_or_create_by! name: 'Q1 Less than 5', formula: 'if (Q1_Earnings < 5, 1, 0)', order: 8
  f9 = DataType.find_or_create_by! name: 'Q3 * Q4 + (Q4 + 10)', formula: 'Q3_times_Q4 + Q4_plus_10', order: 9
  3.times do
    start_date = FFaker::Time.date
    project = Project.create! name: "#{ FFaker::Address.neighborhood } Ranch",
                              acres: Random.new.rand(1..69),
                              date_closed: FFaker::Time.date,
                              restricted_endowment: Random.new.rand(1..69),
                              cap_rate: Random.new.rand(1..69),
                              admin_rate: Random.new.rand(1..69),
                              total_upfront: Random.new.rand(1..69),
                              years_upfront: Random.new.rand(1..69),
                              earnings_begin: start_date
    for yyyy in (Date.parse(start_date).year)..Date.today.year
      y = Year.find_or_create_by!(year: yyyy)
      year = ProjectYear.create! date: yyyy, project_id: project.id, year: y
      f1_value = DataValue.create! value: 5.0,
                                   project_year_id: year.id,
                                   data_type_id: f1.id
      f2_value = DataValue.create! value: 10.0,
                                   project_year_id: year.id,
                                   data_type_id: f2.id
      f3_value = DataValue.create! value: 15.0,
                                   project_year_id: year.id,
                                   data_type_id: f3.id
      f4_value = DataValue.create! value: 20.0,
                                   project_year_id: year.id,
                                   data_type_id: f4.id
      f5_value = DataValue.create! value: 0.0,
                                   project_year_id: year.id,
                                   data_type_id: f5.id
      f6_value = DataValue.create! value: 0.0,
                                   project_year_id: year.id,
                                   data_type_id: f6.id
      f7_value = DataValue.create! value: 0.0,
                                   project_year_id: year.id,
                                   data_type_id: f7.id
      f8_value = DataValue.create! value: 0.0,
                                   project_year_id: year.id,
                                   data_type_id: f8.id
      f9_value = DataValue.create! value: 0.0,
                                   project_year_id: year.id,
                                   data_type_id: f9.id
    end
  end
end

def demo
  f1 = Data.find_or_create_by! name: 'who', formula: 'kwu + isayuh'
  f2 = Data.find_or_create_by! name: 'yungCS G O D'
  f3 = Data.find_or_create_by! name: 'isayuh'
  f4 = Data.find_or_create_by! name: 'kwu'
  f5 = Data.find_or_create_by! name: 'poop', formula: '10'
  f6 = Data.find_or_create_by! name: 'jodreen'
  f7 = Data.find_or_create_by! name: 'ray', formula: 'yungCS_G_O_D * yungCS_G_O_D'
  f8 = Data.find_or_create_by! name: 'ugh', formula: 'poop * jodreen'
  3.times do
    project = Project.create! name: FFaker::Name.name,
                              acres: Random.new.rand(1..69),
                              date_closed: FFaker::Time.date,
                              restricted_endowment: Random.new.rand(1..69),
                              cap_rate: Random.new.rand(1..69),
                              admin_rate: Random.new.rand(1..69),
                              total_upfront: Random.new.rand(1..69),
                              years_upfront: Random.new.rand(1..69),
                              earnings_begin: FFaker::Time.date
    for yyyy in 2068..2070
      year = Year.create! date: yyyy, project_id: project.id
      f1_value = DataValue.create! value: 0.0,
                                   project_year_id: year.id,
                                   data_type_id: f1.id
      f2_value = DataValue.create! value: 103.0,
                                   project_year_id: year.id,
                                   data_type_id: f2.id
      f3_value = DataValue.create! value: 102.0,
                                   project_year_id: year.id,
                                   data_type_id: f3.id
      f4_value = DataValue.create! value: 69.0,
                                   project_year_id: year.id,
                                   data_type_id: f4.id
      f5_value = DataValue.create! value: 0.0,
                                   project_year_id: year.id,
                                   data_type_id: f5.id
      f6_value = DataValue.create! value: 1.0,
                                   project_year_id: year.id,
                                   data_type_id: f6.id
      f7_value = DataValue.create! value: 0.0,
                                   project_year_id: year.id,
                                   data_type_id: f7.id
      f8_value = DataValue.create! value: 0.0,
                                   project_year_id: year.id,
                                   data_type_id: f8.id
    end
  end
end

development
