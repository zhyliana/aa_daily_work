class CatRentalRequest < ActiveRecord::Base
  STATUSES = %w(APPROVED DENIED PENDING)

  belongs_to(
    :cat,
    class_name: 'Cat',
    primary_key: :id,
    foreign_key: :cat_id
  )

  validates(
    :start_date,
    :end_date,
    :cat_id,
    :status,
    presence: true
  )

  validates :status, presence: true, inclusion: STATUSES
  validate :overlapping_approved_requests?

  def approve!
    before_action check_owner(Cat.find_by_id(cat_id))

    unless self.status == 'PENDING'
      errors[:status] << "This request is not pending"
    end
    transaction do
     self.status = 'APPROVED'
     self.save!
     overlapping_pending_requests.each { |request| request.deny! }
    end
  end

  def deny!
    before_action check_owner(Cat.find_by_id(cat_id))
    transaction do
     self.status = 'DENIED'
     self.save!
    end
  end

  private

  def overlapping_requests
    CatRentalRequest.all.where(
      "((? BETWEEN start_date AND end_date)
      OR (? BETWEEN start_date AND end_date))
      OR ((start_date BETWEEN ? AND ?)
      OR (end_date BETWEEN ? AND ? ))
      AND cat_id = ?",
      start_date, end_date, start_date, end_date, start_date, end_date, cat_id
    )
  end

  def overlapping_approved_requests?
    unless overlapping_requests.where("status = 'APPROVED'").empty?
      errors[:id] << "Overlaps with approved request"
    end
  end

  def overlapping_pending_requests?
    unless overlapping_requests.where("status = 'PENDING'").empty?
      errors[:id] << "Overlapping pending request"
    end
  end

  def check_owner(cat)
    unless @session_user.id = cat.user_id
      flash[:notice] = "Can't edit someone else's cat!"
      redirect_to cats_url
    end
  end
end

