class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.string :user_name, null: false
      t.text :comment, null: false, default: ''
      t.references :poll, null: false, foreign_key: true

      t.timestamps
    end
  end
end
