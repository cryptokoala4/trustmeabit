class CreateWallet < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.string :wallet
      t.references :user, index: true, foreign_key: true
    end
  end
end
