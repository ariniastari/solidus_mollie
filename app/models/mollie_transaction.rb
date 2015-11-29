class MollieTransaction < ActiveRecord::Base
  has_many :payments, as: :source
end
