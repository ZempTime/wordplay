class Entry < ActiveRecord::Base
  validates :sentence, presence: true
end
