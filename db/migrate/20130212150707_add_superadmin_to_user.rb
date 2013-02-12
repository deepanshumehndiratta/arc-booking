class AddSuperadminToUser < ActiveRecord::Migration
  def up
    add_column :users, :superadmin, :boolean,
                                    :null => false,
                                    :default => false
    add_column :users, :projector_admin, :boolean,
                                    :null => false,
                                    :default => false
    User.create!(:name => 'Super Administrator',:email => 'superadmin@arc.com', :password => 'abc#1234', :superadmin => true)
    User.create!(:name => 'Projector Administrator',:email => 'projector@arc.com', :password => '1#2#3#4#', :projector_admin => true)
  end

  def down
    remove_column :users, :superadmin, :projector_admin
    User.find_by_email('superadmin@arc.com').try(:delete)
    User.find_by_email('projector@arc.com').try(:delete)
  end
end