class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.integer :level
      t.string :question
      t.string :answer
      t.timestamps
    end
  end
end
