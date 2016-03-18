class Student < ActiveRecord::Base
  # implement your Student model here
  belongs_to :teacher
  validates :email, uniqueness: true, format: {with: /\A[\w\d\._%+-]+@[\w\d.-]+\.\w{2,}\z/, message: 'must be a valid email'}
  validates :birthday, presence: true
  validate :cannot_be_a_toddler

  def cannot_be_a_toddler
    if age<=3
      errors.add(:birthday, "students must be 4 years or older")
    end
  end

  def name 
    self.first_name + " " + self.last_name
  end

  def age 
    if Date.today.month>self.birthday.year
      Date.today.year - self.birthday.year
    else
      Date.today.year - self.birthday.year - 1
    end
  end

  after_save :add_teacher, if: :teacher
  def add_teacher
    teacher.last_student_added_at = Date.today
    teacher.save
  end

end