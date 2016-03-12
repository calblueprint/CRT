require 'tsort'

# Topological sorting hash
class TsortableHash < Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

class ParseFormulaService
  class << self
    def update_data_values(project, data_types)
      projects = Project.all

      # Find dependencies of each data value
      dependency_graph = TsortableHash[]
      fill_dependency_graph(project, data_types, dependency_graph)
      # Calculate data values in topological order

      dependency_graph.tsort.each do |data_value|
        formula = data_value.formula
        unless formula.blank?
          # Initialize calculator and year
          calculator = Dentaku::Calculator.new
          project_year = data_value.project_year_id

          # Check for project attributes
          store_project_attributes_from_formula(formula, calculator, projects)
          store_formula_values_in_calculator(data_value, data_types, project_year, formula, calculator)

          # Check for data values referencing other data values
          store_data_values_from_formula(calculator, data_value, projects)

          # Evaluate formula and save
          save_formula_calculation(formula, calculator, data_value)
        end
      end
    end

    private

    def fill_dependency_graph(project, data_types, dependency_graph)
      project.data_values.each do |data_value|
        # Only calculate data values in this project
        formula = data_value.formula
        unless formula.blank?
          project_year = data_value.project_year
          dependencies = []
          data_types.each do |data_type|
            if includes(formula, data_type)
              dependencies.push(DataValue.find_by(project_year: project_year, data_type: data_type))
            end
            if includes_prev(formula, data_type)
              dependency = data_value.previous_data_value
              dependencies.push(dependency) if dependency
            end
          end
          dependency_graph[data_value] = dependencies
        else
          dependency_graph[data_value] = []
        end
      end
    end

    def store_project_attributes_from_formula(formula, calculator, projects)
      formula.split(' ').each do |token|
        projects.each do |p|
          name = underscore(p.name)
          tokens = token.split('.')
          next unless token.include?(name) && tokens.size == 2
          attribute = remove_parens(tokens[1].downcase)
          value = p.attributes[attribute]
          value /= 100 if rate?(attribute)
          name = dotdotscore(remove_parens(token))
          calculator.store(name => value)
        end
      end
    end

    def store_data_values_from_formula(calculator, data_value, projects)
      if data_value.input_formula
        formula = data_value.input_formula
        formula.split(' ').each do |token|
          projects.each do |p|
            name = underscore(p.name)
            tokens = token.split('.')
            next unless token.include?(name) && tokens.size == 3
            date = tokens[1].to_i
            data_type_name = tokens[2].split('_').join(' ')
            data_type = DataType.find_by_name(data_type_name)
            project = Project.includes(:project_years).find_by_name(p.name)
            project_year = project.project_years.find_by(date: date, project: project)
            target_data_value = project_year.data_values.find_by(project_year: project_year, data_type: data_type)

            # Calculate the formula value based in the input formula
            data_value.formula_value = target_data_value.formula_value
            data_value.input_formula = formula
            calculator.store(dotdotscore(token) => data_value.formula_value)
          end
        end
      end
    end

    def store_formula_values_in_calculator(data_value, data_types, project_year, formula, calculator)
      data_types.each do |data_type|
        if includes(formula, data_type)
          name = underscore(data_type.name)
          other_data_value = DataValue.find_by(project_year: project_year, data_type: data_type)
          value = other_data_value.value || other_data_value.formula_value
          calculator.store(name => value)
        end
        next unless includes_prev(formula, data_type)
        name = underscore(data_type.name) + '_func_prev'
        dependency = data_value.previous_data_value
        next unless dependency
        value = dependency.value
        value = dependency.formula_value ? dependency.formula_value : 0 unless value
        calculator.store(name => value)
      end
    end

    def save_formula_calculation(formula, calculator, data_value)
      formula = dotdotscore(formula)
      data_value.formula_value = calculator.evaluate(formula)
      data_value.formula_value = data_value.formula_value.round(4) if data_value.formula_value
      data_value.save!
    end

    def underscore(string)
      string.split(' ').join('_')
    end

    def dotdotscore(string)
      string.split('.').join('_func_')
    end

    def includes(formula, data_type)
      symbols = [' ', '+', '-', '*', '/', '%', ',', '=', '>', '<', ')', '(', '!']
      formula += ' '
      variable = underscore(data_type.name)
      symbols.each do |symbol|
        return true if formula.include?(variable + symbol)
      end
      false
    end

    def includes_project(formula, project)
      variable = underscore(project.name)
      formula.include?(variable)
    end

    def includes_prev(formula, data_type)
      variable = underscore(data_type.name)
      return true if formula.include?(variable + '.prev')
      false
    end

    def remove_parens(string)
      string[0] = '' if string[0] == '('
      string[-1] = '' if string[-1] == ')'
      string
    end

    def rate?(attribute)
      attribute.split('_')[1] == 'rate'
    end
  end
end
