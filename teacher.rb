class Teacher < ActiveRecord::Base
  
  has_many :students
  
  validates :email, uniqueness: true
  validate :hire_date_cannot_be_after_retirement_date

  def hire_date_cannot_be_after_retirement_date
    if hire_date && retirement_date && hire_date > retirement_date
      errors.add(:retirement_date, 'retirement_date must be after hire_date')
    end
  end

  def days_employed
    if retirement_date > Date.today
      Date.today.julian - hire_date.julian
    else
      retirement_date.julian - hire_date.julian
    end
  end

  after_save :retired_teacher, if: :retirement_date
  def retired_teacher
    students.each do |s|
      s.teacher_id = nil 
    end
  end

end
