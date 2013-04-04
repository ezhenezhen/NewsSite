# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  up_votes   :integer          default(0), not null
#  down_votes :integer          default(0), not null
#  user_id    :integer
#  votes      :integer
#

class Message < ActiveRecord::Base
  make_voteable
  has_one :user
  attr_accessible :content, :name, :user, :user_id, :votes
end
