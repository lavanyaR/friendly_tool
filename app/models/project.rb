class Project < ActiveRecord::Base
  attr_accessible :description, :title

  validates :title, :presence => true

  has_many :tasks
end
