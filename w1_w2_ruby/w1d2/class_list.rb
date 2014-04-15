class Student
  attr_reader :first_name, :last_name, :courses

  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
    @courses = []
  end

  def name
    "#{first_name} #{last_name}"
  end

  def enroll(course)
    @courses << course
    course.enrolled_students << self
  end

  def course_load
    course_load = Hash.new(0)
    @courses.each do |course|
      course_load[course.department] += course.credits
    end
    course_load
  end

end

class Course
  attr_reader :enrolled_students, :department, :credits

  def initialize(course_name, department, credits)
    @enrolled_students = []
    @course_name = course_name
    @department = department
    @credits = credits
  end

  def students
    @enrolled_students
  end

  def add_student(student)
    student.enroll(self)
  end

end

buck = Student.new("Buck","Shlegeris")
jon = Student.new("jon","doe")
jane = Student.new("jane","Smith")

bio = Course.new("biology", "life sciences", 5)
calc = Course.new("calculus", "math", 5)
chem = Course.new("chemistry", "life sciences", 4)
art = Course.new("art history", "humanities", 5)
history = Course.new("history", "humanities", 3)

p jane.name

jane.enroll(art)
jane.enroll(bio)
jane.enroll(chem)

p jane.course_load
