class AddBookPromoToContests < ActiveRecord::Migration
  def change
    add_column :contests, :book_promo, :string
  end
end
