class WalletsController < ApplicationController
  before_action :authenticate_user!

  def index
    @wallet = Blockchain::Wallet.new(ENV['BITCOIN_ID'], ENV['BITCOIN_PASSWORD'])

    @addresses = @wallet.list_addresses()
      @addresses.each do |a|
          puts a.balance
      end

    render json: {
      balance: @balance,
      address: @addresses
      }
  end

  def show
    @wallet = Blockchain::Wallet.new(ENV['BITCOIN_ID'], ENV['BITCOIN_PASSWORD'])
    @user_wallet = current_user.wallets.first.wallet
    addr = @wallet.get_address(@user_wallet, confirmations = 2)


    # @addresses = @wallet.list_addresses()
      # @addresses.each do |a|
      #     puts a.balance
      # end

    @balance = addr.balance


    render json: {
      balance: @balance,
      # wallet: @wallet,
      address: @user_wallet

      }
  end

  def create
    @wallet = Blockchain::Wallet.new(ENV['BITCOIN_ID'], ENV['BITCOIN_PASSWORD'])
    @new_wallet = current_user.wallets.create(wallet: @wallet.new_address.address)
    if @new_wallet
      render json: {wallet: @wallet.new_address }
    else
      render json: {message: "there was an error"}
    end
  end
end
