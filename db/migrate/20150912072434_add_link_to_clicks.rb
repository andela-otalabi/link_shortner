class AddLinkToClicks < ActiveRecord::Migration
  def change
    add_reference :clicks, :link, index: true, foreign_key: true
  end
end
