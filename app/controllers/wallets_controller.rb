class WalletsController < ApplicationController
  def index
  end

  def show
     @wallet = Blockchain::Wallet.new(ENV['BITCOIN_ID'], ENV['BITCOIN_PASSWORD'])
    begin
      @addresses = @wallet.list_addresses()
    rescue Exception => e
      puts e
    end
      @addresses.each do |a|
          puts a.balance
      end
    begin
      @balance = @wallet.get_balance()
    rescue Exception => e
      puts e
    end

    render json: {
      balance: @balance,
      # wallet: @wallet,
      address: @addresses
      }
  end

  def create
     @wallet = Blockchain::Wallet.new(ENV['BITCOIN_ID'], ENV['BITCOIN_PASSWORD'])
    begin
      render json: {
        wallet: @wallet.new_address
      }
    rescue Exception => e
      puts e
    end
  end
end
