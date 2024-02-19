class CreateChoicecandidates < ActiveRecord::Migration[7.0]
  def change
    create_table :choicecandidates do |t|
      t.string :title
      t.references :candidate, null: false, foreign_key: true

      t.timestamps
    end
  end
end
