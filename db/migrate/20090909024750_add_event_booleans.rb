class AddEventBooleans < ActiveRecord::Migration
  def self.up
    change_table :pages do |t|
      t.boolean :all_day_event
      t.boolean :no_end_time
    end
  end

  def self.down
    change_table :pages do |t|
      t.remove :all_day_event
      t.remove :no_end_time
    end
  end
end
