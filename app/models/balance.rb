class Balance < ApplicationRecord
  belongs_to :address
  belongs_to :asset
end
