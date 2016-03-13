def create_specific_projects
  f1 = DataType.find_or_create_by! name: 'Q1 Earnings', order: 1
  f2 = DataType.find_or_create_by! name: 'Q2 Earnings', order: 2
  f3 = DataType.find_or_create_by! name: 'Q3 Earnings', order: 3
  f4 = DataType.find_or_create_by! name: 'Q4 Earnings', order: 4
  f5 = DataType.find_or_create_by! name: 'Earnings', formula: 'Q1_Earnings + Q2_Earnings + Q3_Earnings + Q4_Earnings', order: 5
  f6 = DataType.find_or_create_by! name: 'Q3 times Q4', formula: 'Q3_Earnings * Q4_Earnings', order: 6
  f7 = DataType.find_or_create_by! name: 'Q4 plus 10', formula: 'Q4_Earnings + 10', order: 7
  f8 = DataType.find_or_create_by! name: 'Q1 Less than 5', formula: 'if (Q1_Earnings < 5, 1, 0)', order: 8
  f9 = DataType.find_or_create_by! name: 'Q3 * Q4 + (Q4 + 10)', formula: 'Q3_times_Q4 + Q4_plus_10', order: 9
  projects = []
  3.times do
    start_date = FFaker::Time.date
    project = Project.create! name: "#{ FFaker::Address.neighborhood } Ranch".gsub('/', ' '),
                              acres: Random.new.rand(1..69),
                              date_closed: FFaker::Time.date,
                              restricted_endowment: Random.new.rand(1..69),
                              cap_rate: Random.new.rand(1..69),
                              admin_rate: Random.new.rand(1..69),
                              total_upfront: Random.new.rand(1..69),
                              years_upfront: Random.new.rand(1..69),
                              earnings_begin: start_date
    projects << project
    for yyyy in (Date.parse(start_date).year)..Date.today.year
      y = Year.find_or_create_by!(year: yyyy)
      year = ProjectYear.create! date: yyyy, project_id: project.id, year: y
      f1_value = DataValue.create! formula_value: 5.0,
                                   project_year_id: year.id,
                                   data_type_id: f1.id
      f2_value = DataValue.create! formula_value: 10.0,
                                   project_year_id: year.id,
                                   data_type_id: f2.id
      f3_value = DataValue.create! formula_value: 15.0,
                                   project_year_id: year.id,
                                   data_type_id: f3.id
      f4_value = DataValue.create! formula_value: 20.0,
                                   project_year_id: year.id,
                                   data_type_id: f4.id
      f5_value = DataValue.create! formula_value: nil,
                                   value: nil,
                                   project_year_id: year.id,
                                   data_type_id: f5.id
      f6_value = DataValue.create! formula_value: nil,
                                   project_year_id: year.id,
                                   data_type_id: f6.id
      f7_value = DataValue.create! formula_value: nil,
                                   project_year_id: year.id,
                                   data_type_id: f7.id
      f8_value = DataValue.create! formula_value: nil,
                                   project_year_id: year.id,
                                   data_type_id: f8.id
      f9_value = DataValue.create! formula_value: nil,
                                   project_year_id: year.id,
                                   data_type_id: f9.id
    end
  end
  projects
end

def create_master_project(projects)
  project = Project.create name: "Master", master: true
  f1 = DataType.find_or_create_by! name: 'Q3', order: 1, master: true
  f2 = DataType.find_or_create_by! name: 'Q4', order: 2, master: true
  f3 = DataType.find_or_create_by! name: 'Q1', order: 3, master: true
  f4 = DataType.find_or_create_by! name: 'Q2', order: 4, master: true
  f5 = DataType.find_or_create_by! name: "Total Acres", order: 5, master: true
  f5.formula = create_acre_formula(projects.map(&:name))
  f5.save
  f6 = DataType.find_or_create_by! name: 'CPI Rate', order: 6, master: true
  f7 = DataType.find_or_create_by! name: 'Earnings', order: 7, master: true, formula: 'Q1 + Q2 + Q3 + Q4'
  f8 = DataType.find_or_create_by! name: 'Overhead', order: 8, master: true
  f9 = DataType.find_or_create_by! name: 'Net', order: 9, master: true, formula: "Earnings + Overhead"
  for yyyy in 2010..Date.today.year
    y = Year.find_or_create_by!(year: yyyy)
    year = ProjectYear.create! date: yyyy, project_id: project.id, year: y
    f1_value = DataValue.create! formula_value: Random.new.rand(1000..2000),
                                 project_year_id: year.id,
                                 data_type_id: f1.id
    f2_value = DataValue.create! formula_value: Random.new.rand(1000..2000),
                                 project_year_id: year.id,
                                 data_type_id: f2.id
    f3_value = DataValue.create! formula_value: Random.new.rand(1000..2000),
                                 project_year_id: year.id,
                                 data_type_id: f3.id
    f4_value = DataValue.create! formula_value: Random.new.rand(1000..2000),
                                 project_year_id: year.id,
                                 data_type_id: f4.id
    f5_value = DataValue.create! formula_value: nil,
                                 project_year_id: year.id,
                                 data_type_id: f5.id
    f6_value = DataValue.create! formula_value: Random.new.rand(1..15),
                                 project_year_id: year.id,
                                 data_type_id: f6.id
    f7_value = DataValue.create! formula_value: nil,
                                 project_year_id: year.id,
                                 data_type_id: f7.id
    f8_value = DataValue.create! formula_value: Random.new.rand(1..999),
                                 project_year_id: year.id,
                                 data_type_id: f8.id

    f9_value = DataValue.create! formula_value: nil,
                                 project_year_id: year.id,
                                 data_type_id: f9.id
  end
end

def create_acre_formula(names)
  formula = ''
  names.each do |name|
    formula += name.gsub(' ', '_')
    formula += '.acres + '
  end
  formula[-2..-1]  = ''
  formula
end

def development
  user = User.new email: 'admin@admin.com', password: 'password', password_confirmation: 'password', name: 'Admin'
  user.save validate: false
  projects = create_specific_projects
  create_master_project projects
end


development
