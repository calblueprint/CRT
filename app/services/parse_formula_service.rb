class ParseFormulaService
  def self.update_data_values(project, data_types, data_values)
    @project = project
    @projects = Project.all
    @data_types = data_types
    @data_values = data_values

    # Find dependencies of each data value
    data_values = TsortableHash[]
    @data_values.each do |data_value|
      # Only calculate data values in this project
      next unless @project.project_years.find_by_id(data_value.project_year_id)
      formula = @data_types.find(data_value.data_type_id).formula
      if formula
        year = data_value.project_year_id
        dependencies = []
        @data_types.each do |data_type|
          if includes(formula, data_type)
            dependencies.push(@data_values.find_by(project_year_id: year, data_type: data_type))
          end
          if includes_prev(formula, data_type)
            dependency = data_value.previous_data_value
            dependencies.push(dependency) if dependency
          end
        end
        data_values[data_value] = dependencies
      else
        data_values[data_value] = []
      end
    end

    # Calculate data values in topological order
    data_values.tsort.each do |data_value|
      formula = @data_types.find(data_value.data_type_id).formula
      if formula
        # Initialize calculator and year
        calculator = Dentaku::Calculator.new
        year = data_value.project_year_id

        # Check for project attributes
        formula.split(' ').each do |token|
          @projects.each do |p|
            name = underscore(p.name)
            next unless token.include?(name)
            attribute = remove_parens(token.split('.')[1].downcase)
            value = p.attributes[attribute]
            value /= 100 if rate?(attribute)
            name = dotdotscore(remove_parens(token))
            calculator.store(name => value)
          end
        end

        @data_types.each do |data_type|
          if includes(formula, data_type)
            name = underscore(data_type.name)
            value = @data_values.find_by(project_year: year, data_type: data_type).value
            unless value
              value = @data_values.find_by(project_year: year, data_type: data_type).formula_value
            end
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
        # Evaluate formula and save
        formula = dotdotscore(formula)
        data_value.formula_value = calculator.evaluate(formula)
        data_value.value = data_value.value.round(4) if data_value.value
        data_value.formula_value = data_value.formula_value.round(4) if data_value.formula_value
        data_value.save
      end
    end
    @data_values.sort_by { |year_id| (Year.find_by_id(year_id).year if Year.find_by_id(year_id)) || 9999 }
  end

  private_class_method def self.underscore(string)
    string.split(' ').join('_')
  end

  private_class_method def self.dotdotscore(string)
    string.split('.').join('_func_')
  end

  private_class_method def self.includes(formula, data_type)
    symbols = [' ', '+', '-', '*', '/', '%', ',', '=', '>', '<', ')', '(', '!']
    formula += ' '
    variable = underscore(data_type.name)
    symbols.each do |symbol|
      return true if formula.include?(variable + symbol)
    end
    false
  end

  private_class_method def self.includes_project(formula, project)
    variable = underscore(project.name)
    formula.include?(variable)
  end

  private_class_method def self.includes_prev(formula, data_type)
    variable = underscore(data_type.name)
    return true if formula.include?(variable + '.prev')
    false
  end

  private_class_method def self.remove_parens(string)
    string[0] = '' if string[0] == '('
    string[-1] = '' if string[-1] == ')'
    string
  end

  private_class_method def self.rate?(attribute)
    attribute.split('_')[1] == 'rate'
  end
end
