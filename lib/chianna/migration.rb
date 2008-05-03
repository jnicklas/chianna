migration 1, :create_people_table do
  up do
    create_table :chianna_sessions do 
      column :id,     "integer"
      column :name,   "varchar(255)"
      column :age,    "integer"
    end
    create_table :chianna_components do 
      #column :id,     "integer"
      column :session_key,   "varchar(255)"
    end
  end
  
  down do
    drop_table :chianna_sessions
    drop_table :chianna_components
  end
end