class CreateCrimes < ActiveRecord::Migration
  def change
    create_table :crimes do |t|

      t.timestamps
    end
  end
end
