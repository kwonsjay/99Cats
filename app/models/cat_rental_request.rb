class CatRentalRequest < ActiveRecord::Base
  attr_accessible :cat_id, :start_date, :end_date, :status

  validates :cat_id, :start_date, :end_date, :status, :presence => true

  validate :overlapping_approved_requests

  before_validation do
    self.status ||= "PENDING"
  end

  belongs_to :cat

  def approve!
    self.status = 'APPROVED'
    self.transaction do
      self.save!

      self.overlapping_pending_requests.update_all(:status => "DENIED")
    end
  end

  def deny!
    self.status = 'DENIED'
    self.save
  end

  def pending?
    self.status == 'PENDING'
  end

  private
    def overlapping_requests
      overlapping_results = CatRentalRequest.where(<<-SQL, self.cat_id, self.end_date, self.start_date)
        cat_id = ? AND (start_date <= ? AND end_date >= ?)
      SQL
    end

    def overlapping_pending_requests
      overlapping_requests.where("status = 'PENDING'")
    end

    def overlapping_approved_requests
      overlapping_results = overlapping_requests.where("status = 'APPROVED'")

      if !overlapping_results.all.empty? && overlapping_results.first.id != self.id
        errors[:base] = "Overlapping approved requests"
      end
    end
end
