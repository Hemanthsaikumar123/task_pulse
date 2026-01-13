class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :status
      t.string :priority
      t.date :due_date
      t.datetime :completed_at
      t.references :project, null: false, foreign_key: true
      t.integer :assignee_id

      t.timestamps
    end
  end
end
