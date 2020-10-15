class Point < ApplicationRecord

  # -- [Association] --
  belongs_to :profile  

  # -- [enum] --
  enum events: {
    chore_record: 1,
    chore_cancel: 2,
    gift_exchange: 3
  }
end
