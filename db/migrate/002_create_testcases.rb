class CreateTestcases < ActiveRecord::Migration
  def change
    create_table :testcases do |t|
      t.string :name
      t.datetime :time_last_run
      t.text :description
      t.string :status
      t.string :path
      t.string :test_type
      t.string :project_identifier
    end
  end
end
