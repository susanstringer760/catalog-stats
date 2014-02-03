class CreateNagiosDatasetContact < ActiveRecord::Migration

  def change

    create_table :nagios_contact do |t|
      t.integer :contact_id,              :null => false
      t.integer :nagios_dataset_check_id, :null => false
      t.string  :contact_column,          :null => false # 'phone' or 'email'
    end

    add_index :nagios_contact,  :contact_id
    add_index :nagios_contact,  :nagios_dataset_check_id

    create_table :nagios_contactgroup do |t|
      t.integer :project_id
      t.string  :name, :null => false
    end

    add_index :nagios_contactgroup, :project_id

    create_table :nagios_contact_contactgroup, :id => false do |t|
      t.integer :nagios_contact_id,      :null => false
      t.integer :nagios_contactgroup_id, :null => false
    end

    add_index :nagios_contact_contactgroup, :nagios_contact_id
    add_index :nagios_contact_contactgroup, :nagios_contactgroup_id

    devinb_hash = { :affiliation       => 'ncar_ucar',
                    :primary_name      => 'person',
                    :postal_code       => '80307-3000',
                    :state             => 'CO',
                    :phone             => '303-497-8815',
                    :organization_name => 'NCAR/EOL',
                    :city              => 'Boulder',
                    :short_name        => 'devinb',
                    :address           => 'P.O. Box 3000',
                    :active_editor     => true,
                    :email             => 'devinb@ucar.edu',
                    :person_name       => 'Devin Brown',
                    :country           => 'US'
                  }

    Contact.create( devinb_hash ) if Contact.where( devinb_hash ).empty?

  end
end