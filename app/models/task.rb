class Task < ActiveRecord::Base
  attr_accessible :admin_user_id, :due_date, :is_done, :project_id, :title
  belongs_to :project
  belongs_to :admin_user
  validates :title, :project_id, :admin_user_id, :presence => true
  validates :is_done, :inclusion => { :in => [true, false] }


  scope :all, :default => true
  scope :due_this_week do |tasks|
    tasks.where('due_date > ? and due_date < ?', Time.now, 1.week.from_now)
  end
  scope :late do |tasks|
    tasks.where('due_date < ?', Time.now)
  end
  scope :mine do |tasks|
    tasks.where(:admin_user_id => current_admin_user.id)
  end
end
