class Cat < ActiveRecord::Base
  COLORS =  %w(orange grey black white brown purple blue)

  has_many(
    :cat_rental_requests,
    class_name: 'CatRentalRequest',
    primary_key: :id,
    foreign_key: :cat_id,
    dependent: :destroy
    )

  belongs_to(
    :user,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :user_id
    )

  validates(
    :age,
    :birth_date,
    :color,
    :name,
    :sex,
    presence: true
    )


  validates :age, numericality: true
  validates :color, inclusion: COLORS
  validates :sex, inclusion:  %w(M F)
end
