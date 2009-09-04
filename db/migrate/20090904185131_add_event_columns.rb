class AddEventColumns < ActiveRecord::Migration
  def self.up
    change_table :pages do |t|
      t.datetime :event_start
      t.datetime :event_end
    end
  end

  def self.down
    change_table :pages do |t|
      t.remove :event_start
      t.remove :event_end
    end
  end
end
