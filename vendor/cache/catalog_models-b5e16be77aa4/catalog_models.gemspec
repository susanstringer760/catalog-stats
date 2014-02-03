# -*- encoding: utf-8 -*-
# stub: catalog_models 1.7.1 ruby lib

Gem::Specification.new do |s|
  s.name = "catalog_models"
  s.version = "1.7.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Erik Johnson, NCAR", "John Allison, NCAR", "Susan Stringer, NCAR", "Greg Stossmeister, NCAR"]
  s.date = "2014-02-03"
  s.description = "ActiveRecord models for the CTM Catalog-2.0 Framework"
  s.email = ["ej@ucar.edu", "jja@ucar.edu", "snorman@ucar.edu", "gstoss@ucar.edu"]
  s.files = [".gitignore", ".rvmrc", "CHANGELOG.md", "Gemfile", "README.md", "Rakefile", "benchmark_finder.sh", "bin/finder", "catalog_models.gemspec", "config/database.yml.sample", "db/migrate/001_add_menu_item.rb", "db/migrate/002_add_menu_item_project.rb", "db/migrate/006_create_map_tables.rb", "db/migrate/007_create_nagios_dataset_options.rb", "db/migrate/008_create_nagios_dataset_contact.rb", "db/migrate/009_create_ui_platform_run_date.rb", "db/schema.rb", "doc/DEVELOPMENT.md", "lib/catalog_models.rb", "lib/catalog_models/models.rb", "lib/catalog_models/models/catalog_ingest_item.rb", "lib/catalog_models/models/category.rb", "lib/catalog_models/models/contact.rb", "lib/catalog_models/models/datafile.rb", "lib/catalog_models/models/dataset.rb", "lib/catalog_models/models/format.rb", "lib/catalog_models/models/frequency.rb", "lib/catalog_models/models/horizontal_resolution.rb", "lib/catalog_models/models/ingest_approval.rb", "lib/catalog_models/models/instrument.rb", "lib/catalog_models/models/language.rb", "lib/catalog_models/models/map.rb", "lib/catalog_models/models/map_layer.rb", "lib/catalog_models/models/menu_item.rb", "lib/catalog_models/models/menu_item_project.rb", "lib/catalog_models/models/nagios_contact.rb", "lib/catalog_models/models/nagios_contactgroup.rb", "lib/catalog_models/models/nagios_dataset_check.rb", "lib/catalog_models/models/nagios_project.rb", "lib/catalog_models/models/platform.rb", "lib/catalog_models/models/platform_run_date.rb", "lib/catalog_models/models/product.rb", "lib/catalog_models/models/project.rb", "lib/catalog_models/models/project_sort.rb", "lib/catalog_models/models/report_element.rb", "lib/catalog_models/models/status_item.rb", "lib/catalog_models/models/status_report.rb", "lib/catalog_models/models/vertical_resolution.rb", "lib/catalog_models/models/xlink.rb", "lib/catalog_models/requireall.rb", "lib/catalog_models/validators.rb", "lib/catalog_models/validators/directory_form_validator.rb", "lib/catalog_models/validators/eol_directory_location_validator.rb", "lib/catalog_models/validators/format_regex_validator.rb", "lib/catalog_models/validators/no_dot_slash_validator.rb", "lib/catalog_models/validators/no_dot_validator.rb", "lib/catalog_models/validators/no_whitespace_validator.rb", "lib/catalog_models/validators/non_blank_validator.rb", "lib/catalog_models/validators/reasonable_dates_validator.rb", "lib/catalog_models/validators/unique_or_nil_validator.rb", "lib/catalog_models/version.rb", "ruby benchmarks.md", "spec/lib/emdac_validation1_spec.rb", "spec/lib/emdac_validation2_spec.rb", "spec/lib/emdac_validation3_spec.rb", "spec/models/catalog_filename_component_validations_spec.rb", "spec/models/datafile_spec.rb", "spec/models/datafile_validations_spec.rb", "spec/models/dataset_validations_spec.rb", "spec/models/format_spec.rb", "spec/models/format_validations_spec.rb", "spec/spec_helper.rb"]
  s.homepage = "https://github.com/ncareol/catalog_models"
  s.rubygems_version = "2.2.1"
  s.summary = "Gem for catalog models"
  s.test_files = ["spec/lib/emdac_validation1_spec.rb", "spec/lib/emdac_validation2_spec.rb", "spec/lib/emdac_validation3_spec.rb", "spec/models/catalog_filename_component_validations_spec.rb", "spec/models/datafile_spec.rb", "spec/models/datafile_validations_spec.rb", "spec/models/dataset_validations_spec.rb", "spec/models/format_spec.rb", "spec/models/format_validations_spec.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec-rails>, [">= 2.7"])
      s.add_runtime_dependency(%q<activerecord>, ["= 3.2.16"])
      s.add_runtime_dependency(%q<mysql2>, [">= 0"])
      s.add_development_dependency(%q<rubygems-bundler>, [">= 0"])
      s.add_development_dependency(%q<acts_as_fu>, [">= 0"])
    else
      s.add_dependency(%q<rspec-rails>, [">= 2.7"])
      s.add_dependency(%q<activerecord>, ["= 3.2.16"])
      s.add_dependency(%q<mysql2>, [">= 0"])
      s.add_dependency(%q<rubygems-bundler>, [">= 0"])
      s.add_dependency(%q<acts_as_fu>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec-rails>, [">= 2.7"])
    s.add_dependency(%q<activerecord>, ["= 3.2.16"])
    s.add_dependency(%q<mysql2>, [">= 0"])
    s.add_dependency(%q<rubygems-bundler>, [">= 0"])
    s.add_dependency(%q<acts_as_fu>, [">= 0"])
  end
end
