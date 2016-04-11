def create_specific_projects
  data_types = []
  data_types << DataType.find_or_create_by!(name: 'Additional Acres')
  data_types << DataType.find_or_create_by!(name: 'PAR')
  data_types << DataType.find_or_create_by!(name: 'Overhead')
  data_types << DataType.find_or_create_by!(name: 'Temp Restricted Balance')
  data_types << DataType.find_or_create_by!(name: 'Up Front')
  data_types << DataType.find_or_create_by!(name: 'Earnings')
  data_types << DataType.find_or_create_by!(name: 'Funds Available')
  data_types << DataType.find_or_create_by!(name: 'Max Overhead')
  data_types << DataType.find_or_create_by!(name: 'Inflator')
  data_types << DataType.find_or_create_by!(name: 'Expenses')
  data_types << DataType.find_or_create_by!(name: 'Total Expenses')
  data_types << DataType.find_or_create_by!(name: 'Net')
  data_types << DataType.find_or_create_by!(name: 'Temp Restricted Draw')
  data_types << DataType.find_or_create_by!(name: 'Max Possible Draw')
  data_types << DataType.find_or_create_by!(name: 'Admin Draw Max')
  data_types << DataType.find_or_create_by!(name: 'Restricted Draw Max')
  data_types << DataType.find_or_create_by!(name: 'Admin Draw')
  data_types << DataType.find_or_create_by!(name: 'Restricted Draw')
  data_types << DataType.find_or_create_by!(name: 'Total Draw')
  data_types << DataType.find_or_create_by!(name: 'Edowment Add Back')
  if Rails.env.production?
    return
  end
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
      data_types.each do |data_type|
        f9_value = DataValue.create! value: Random.new.rand(1..30),
                                     project_year_id: year.id,
                                     data_type_id: data_type.id
      end
    end
  end
  projects
end

def create_master_project_quarters
  quarters = []
  [3, 4, 1, 2].each do |i|
    quarters << DataType.find_or_create_by!(name: "Q#{i} Balance", master: true)
    quarters << DataType.find_or_create_by!(name: "Q#{i} Earnings", master: true)
  end
  quarters
end

def create_master_project(projects)
  project = Project.create name: "Master", master: true
  input_fields = create_master_project_quarters
  formula_fields = []
  total_acres = DataType.find_or_create_by! name: "Total Acres", master: true,
                                            formula: create_formula(projects.map(&:name), "acres")
  formula_fields << total_acres
  oh_endowment = DataType.find_or_create_by! name: 'OH Endowment', master: true,
                                             formula: create_formula(projects.map(&:name),
                                                                     "restricted_endowment")
  formula_fields << oh_endowment
  cpi_rate = DataType.find_or_create_by! name: 'CPI Rate', master: true
  formula_fields
  formula_fields << DataType.find_or_create_by!(name: 'Earnings', master: true,
                              formula: 'Q1_Earnings+ Q2_Earnings + Q3_Earnings + Q4_Earnings')
  formula_fields << DataType.find_or_create_by!(name: 'Expenses', master: true)
  input_fields << DataType.find_or_create_by!(name: 'Overhead', master: true)
  input_fields << DataType.find_or_create_by!(name: 'EOY Unit Actual', master: true)
  formula_fields << DataType.find_or_create_by!(name: 'Net', master: true,
                              formula: "Earnings + Upfront - Expenses - Overhead")
  formula_fields << DataType.find_or_create_by!(name: "Admin Draw", master: true)
  formula_fields << DataType.find_or_create_by!(name: "Restricted Draw", master: true)
  formula_fields << DataType.find_or_create_by!(name: "Restricted Total Draw", master: true)
  formula_fields << DataType.find_or_create_by!(name: "Endowment Add Back", master: true)
  formula_fields << DataType.find_or_create_by!(name: "Professional Services", master: true)
  if Rails.env.production?
    return
  end
  for yyyy in 2010..Date.today.year
    y = Year.find_or_create_by!(year: yyyy)
    year = ProjectYear.create! date: yyyy, project_id: project.id, year: y
    input_fields.each do |input_field|
      DataValue.create! value: Random.new.rand(1000..2000), project_year_id: year.id,
                        data_type_id: input_field.id
    end
    formula_fields.each do |formula_field|
      DataValue.create! project_year_id: year.id,
                        data_type_id: formula_field.id
    end
    DataValue.create! value: Random.new.rand(1..5), project_year_id: year.id,
                      data_type_id: cpi_rate.id
  end
end

def create_formula(names, attribute)
  formula = ''
  names.each do |name|
    formula += name.gsub(' ', '_')
    formula += ".#{ attribute} + "
  end
  formula[-2..-1]  = ''
  formula
end

def development
  user = User.new email: 'admin@admin.com', password: 'password', password_confirmation: 'password',
                  name: 'Admin', admin: true
  user.save validate: false
  projects = create_specific_projects
  create_master_project projects
end


development
