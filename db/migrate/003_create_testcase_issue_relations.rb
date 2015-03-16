class CreateTestcaseIssueRelations < ActiveRecord::Migration
  def change
    create_table :testcase_issue_relations do |t|
      t.references :issue, index: true
      t.references :testcase, index: true
    end
    add_index :testcase_issue_relations, :issue_id
    add_index :testcase_issue_relations, :testcase_id
  end
end
