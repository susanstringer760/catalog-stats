def load_models

  # connect to db and load active record models

  conf = YAML.load_file('config/database.yml')
  #ActiveRecord::Base.establish_connection(conf['development'])
  ActiveRecord::Base.establish_connection(conf)
  
  ActiveRecord::Base.pluralize_table_names = false
  ActiveRecord::Base::default_timezone = :utc
  
  require 'catalog_models/validators'
  require 'catalog_models/models'

end

def get_datasets(project_id)

  # get project datasets
  Project.find(project_id).datasets.catalog_viewable

end

def get_datafiles_by_category(project_id)

  # return hash where key is category and value is list 
  # of file objects for this category
  project_datasets = get_datasets(project_id)

  tmp_hash = Hash.new{|hash, key| hash[key] = Array.new}
  stats_hash = Hash.new{|hash, key| hash[key] = Array.new}

  # loop through each dataset and stuff into
  # where the key is the category and the value
  # is an array of datafile objects 
  project_datasets.each {|d| 
    category = d.categories[0]
    tmp_hash[category.short_name].push(d.datafiles)
  }

  # now flatten since the value of the hash
  # is an array of arrays
  tmp_hash.each {|category,datafile_arr|
    stats_hash[category] = datafile_arr.flatten
  }

  stats_hash

end

def get_catalog_projects

  # get an array of field catalog projects
  catalog_projects_hash = Hash.new

  projects = Project.find(:all)

  projects.each {|project|
    next if (project.datasets.length==0)
    catalog_projects_hash[project.name] = project.id if (project.datasets[0].catalog_visible)
  }

  catalog_projects_hash


end

def print_report(stats_hash, out_fname)

  # print out the stats
  fh = File.open(out_fname, 'w')
  stats_hash.keys.each { |category|
    num_files = stats_hash[category].length
    puts "#{category}: #{num_files}"
    fh.write("#{category}: #{num_files}\n")
  }
  fh.close

end

def get_categories(project_id)

  # get the available categories for the project
  dataset_arr = get_datasets(project_id)
  
  # arr of categories for the datasets
  category_arr = dataset_arr.map{|dataset| dataset.categories}.flatten
  category_hash = Hash.new

  # return hash where key is category short_name and value is category id 
  category_arr.map{|category| category_hash[category.short_name] = category.id}
  category_hash

end
