# Coding a formula

## Basic Example

The following piece of code creates a variable named `flat_tax_on_salary`, representing an imaginary tax of 25% on salaries, paid monthly by individuals (not households).

```py
class flat_tax_on_salary(Variable):
    value_type = float
    entity = Person
    definition_period = MONTH
    label = u"Individualized and monthly paid tax on salaries"
    
    def formula(person, period):
        salary = person('salary', period)
        return salary * 0.25
```

Let's explain in details the different parts of the code:
- `class flat_tax_on_salary(Variable):` declares a new variable with the name `flat_tax_on_salary`.
- Metadatas:
  - `value_type = float` declares the type of the variable. Possible types are the basic python types:
    - `bool`: boolean
    - `date`: date
    - `Enum`: discrete value (from an enumerable)
    - `float`: float
    - `int`: integer
    - `str`: string
  - `entity = Person` declares which entity the variable is defined for, e.g. a person, a family, a tax household, etc. The different available entities are defined by each tax and benefit system. In `openfisca-france`, a variable can be defined for an `Individu`, a `Famille`, a `FoyerFiscal`, or a `Menage`.
  - `label = u"Individualized..."` gives, in a human-readable language, concise information about the variable.
  - `definition_period = MONTH` states that the variable will be computed on months.
- Formula:
  - `def formula(person, period):` declares the formula that will be used to calculate the `flat_tax_on_salary` for a given `person` at a given `period`. Because `definition_period = MONTH`, `period` is constrained to be a month.
  - `salary = person('salary', period)` calculates the salary of the person, for the given month. This will, of course, work only if `salary` is another variable in the tax and benefit system.
  - `return salary * 0.25` returns the result for the given period.
  - [Dated Formulas](40_legislation_evolutions.md) have a start and/or an end date.
## Testing a formula

To make sure that the formula you have just written works the way you expect, you have to test it. Tests about legislation are written in a [YAML syntax](writing_yaml_tests.md). The `flat_tax_on_salary` formula can for instance be tested with the following test file:

```yaml
- name: "Flax tax on salary - No income"
  period: 2017-01
  input_variables:
    salary: 0
  output_variables:
    flat_tax_on_salary: 0

- name: "Flax tax on salary - With income"
  period: 2017-01
  input_variables:
    salary: 2000
  output_variables:
    flat_tax_on_salary: 500
```

You can check the [YAML tests documentation](writing_yaml_tests.md) to learn more about how to write YAML tests, and how to run them.

## Example with legislation parameters

To access a common legislation parameter, a third parameter can be added to the function signature. The previous formulas could thus be rewritten:

```py
class flat_tax_on_salary(Variable):
    value_type = float
    entity = Person
    label = u"Individualized and monthly paid tax on salaries"
    definition_period = MONTH

    def formula(person, period, parameters):
        salary = person('salary', period)

        return salary * parameters(period).taxes.salary.rate
```

`parameters` is here a function that be be called for a given period, and returns the whole legislation parameters (in a hierarchical tree structure). You can get the parameter you are interested in by navigating this tree with the `.` notation.
