class CreateActivityLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_logs do |t|
      t.string :action
      t.references :user, null: false, foreign_key: true
      t.string :trackable_type
      t.integer :trackable_id

      t.timestamps
    end
  end
end
