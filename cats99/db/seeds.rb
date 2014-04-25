# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or create!d alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)

ActiveRecord::Base.transaction do
  # CatRentalRequest.create!(:cat_id => 1, :start_date => '2014-04-27', :end_date => '2014-05-08', :status => 'APPROVED').save
  CatRentalRequest.create!(:cat_id => 1, :start_date => '2014-09-05', :end_date => '2014-09-15')

  #overlaps w req1 by the start_date
  CatRentalRequest.create!(:cat_id => 1, :start_date => '2014-04-22', :end_date => '2014-04-30')

  #overlaps w req1 by end date
  CatRentalRequest.create!(:cat_id => 1, :start_date => '2014-04-28', :end_date => '2014-05-07')

  CatRentalRequest.create!(:cat_id => 1, :start_date => '2014-04-25', :end_date => '2014-04-27' )

  Cat.create!(:name => "Isosceles", :age => 2, :birth_date => "2012-07-01",
          :color => "orange", :sex => "F")

  Cat.create!(:name => "Bundle", :age => 5, :birth_date => "2009-08-11",
          :color => "black", :sex => "M")

  Cat.create!(:name => "Chien", :age => 1, :birth_date => "2013-03-06",
          :color => "white", :sex => "F")
end