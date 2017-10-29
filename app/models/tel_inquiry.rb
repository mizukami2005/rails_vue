class TelInquiry < ActiveRecord::Base
  belongs_to :user
  before_create :check_sales
  private

  def check_sales
    self.setting = false
    true
  end

end
