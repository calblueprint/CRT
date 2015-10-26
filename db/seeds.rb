# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def test_a
  f1 = DataType.create! name: 'multiply', formula: '69 * 69'
  f2 = DataType.create! name: 'add', formula: '69 + 69'
  f3 = DataType.create! name: 'divide', formula: '69 / 69'
  f4 = DataType.create! name: 'round', formula: 'round(69.69)'
  f5 = DataType.create! name: 'complex', formula: 'if (69 != 69, 1, 69)'
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
                                   year_id: year.id,
                                   data_type_id: f1.id
      f2_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f2.id
      f3_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f3.id
      f4_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f4.id
      f5_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f5.id
    end
  end
end

def test_b
  f1 = DataType.create! name: 'f1', formula: 'f4_jodreen_sucks + 10'
  f2 = DataType.create! name: 'f2', formula: 'if (f1 < 5, 1, 0)'
  f3 = DataType.create! name: 'f3', formula: 'f4_jodreen_sucks + 5'
  f4 = DataType.create! name: 'f4 jodreen sucks', formula: '1'
  f5 = DataType.create! name: 'f5', formula: 'f4_jodreen_sucks * f3'
  f6 = DataType.create! name: 'f6', formula: 'f4_jodreen_sucks + 10'
  f7 = DataType.create! name: 'f7', formula: 'if (f1 < 5, 1, 0)'
  f8 = DataType.create! name: 'f8', formula: 'f4_jodreen_sucks + 5'
  f9 = DataType.create! name: 'f9', formula: 'f1 + f2 + f3 + f4_jodreen_sucks + f5 + f6 + f7 + f8 + f10'
  f10 = DataType.create! name: 'f10', formula: 'f4_jodreen_sucks * f3'
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
                                   year_id: year.id,
                                   data_type_id: f1.id
      f2_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f2.id
      f3_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f3.id
      f4_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f4.id
      f5_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f5.id
      f6_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f6.id
      f7_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f7.id
      f8_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f8.id
      f9_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f9.id
      f10_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f10.id
    end
  end
end

def test_c
  f1 = DataType.create! name: 'f1'
  f2 = DataType.create! name: 'f2'
  f3 = DataType.create! name: 'F3 c'
  f4 = DataType.create! name: 'f4 C'
  f5 = DataType.create! name: 'f5', formula: 'f4_c * f3_c'
  f6 = DataType.create! name: 'f6', formula: 'f4_C + 10'
  f7 = DataType.create! name: 'f7', formula: 'if (f1 < 5, 1, 0)'
  f8 = DataType.create! name: 'f8', formula: 'f4_C + 5'
  f9 = DataType.create! name: 'f9', formula: 'f1 + f2 + F3_c + f4_C + f5 + f6 + f7 + f8 + f10'
  f10 = DataType.create! name: 'f10', formula: 'f4_C * F3_c'
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
      f1_value = DataValue.create! value: 5.0,
                                   year_id: year.id,
                                   data_type_id: f1.id
      f2_value = DataValue.create! value: 10.0,
                                   year_id: year.id,
                                   data_type_id: f2.id
      f3_value = DataValue.create! value: 15.0,
                                   year_id: year.id,
                                   data_type_id: f3.id
      f4_value = DataValue.create! value: 20.0,
                                   year_id: year.id,
                                   data_type_id: f4.id
      f5_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f5.id
      f6_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f6.id
      f7_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f7.id
      f8_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f8.id
      f9_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f9.id
      f10_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f10.id
    end
  end
end

def demo
  f1 = DataType.create! name: 'who', formula: 'kwu + isayuh'
  f2 = DataType.create! name: 'yungCS G O D'
  f3 = DataType.create! name: 'isayuh'
  f4 = DataType.create! name: 'kwu'
  f5 = DataType.create! name: 'poop', formula: '10'
  f6 = DataType.create! name: 'jodreen'
  f7 = DataType.create! name: 'ray', formula: 'yungCS_G_O_D * yungCS_G_O_D'
  f8 = DataType.create! name: 'ugh', formula: 'poop * jodreen'
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
                                   year_id: year.id,
                                   data_type_id: f1.id
      f2_value = DataValue.create! value: 103.0,
                                   year_id: year.id,
                                   data_type_id: f2.id
      f3_value = DataValue.create! value: 102.0,
                                   year_id: year.id,
                                   data_type_id: f3.id
      f4_value = DataValue.create! value: 69.0,
                                   year_id: year.id,
                                   data_type_id: f4.id
      f5_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f5.id
      f6_value = DataValue.create! value: 1.0,
                                   year_id: year.id,
                                   data_type_id: f6.id
      f7_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f7.id
      f8_value = DataValue.create! value: 0.0,
                                   year_id: year.id,
                                   data_type_id: f8.id
    end
  end
end

test_c
