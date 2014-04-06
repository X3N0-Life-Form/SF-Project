class AddUserAttributes < ActiveRecord::Migration
  def change
    add_column :users, :date_of_birth, :string
    add_column :users, :weight, :float
    add_column :users, :ideal_weight, :float
    add_column :users, :do_sport, :boolean
    add_column :users, :would_do_sport, :boolean
  end

  def self.up
    add_column :users, :date_of_birth, :string
    add_column :users, :weight, :float
    add_column :users, :ideal_weight, :float
    add_column :users, :do_sport, :boolean
    add_column :users, :would_do_sport, :boolean
  end

  def self.down
    remove_column :users, :date_of_birth
    remove_column :users, :weight
    remove_column :users, :ideal_weight
    remove_column :users, :do_sport
    remove_column :users, :would_do_sport
  end
   
end
