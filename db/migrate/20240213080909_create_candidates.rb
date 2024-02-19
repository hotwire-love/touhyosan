class CreateCandidates < ActiveRecord::Migration[7.0]
  def change
    create_table :candidates do |t|
      t.string :title
      t.references :pre_poll, null: false, foreign_key: true

      t.timestamps
    end
  end
end
