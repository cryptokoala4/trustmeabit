class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wallet
  before_action :set_user_wallet, only: [:show]

  def index
    @addresses = @wallet.list_addresses()
    @addresses.each do |a|
      puts ">>>>>>>>>>"
      puts a.balance
      puts a.address
      puts a.label
      puts a.total_received
    end

    render json: {
      addresses: @addresses
    }
  end

  def show
    address_object = @wallet.get_address(@user_wallet.wallet, confirmations = 2)

    balance = address_object.balance
    address = address_object.address

    require 'net/http'

    url = URI.parse('https://blockchain.info/rawaddr/' + address)
    req = JSON.parse(Net::HTTP::get(url))

    @transactions = []
    req['txs'].each do |txn|
      txn['out'].each do |txn_detail|
        if txn_detail['addr'] != address
          @transactions << {addr: txn_detail['addr'], amount: txn_detail['value']}
        end
      end
    end

    render json: {
      balance: balance,
      address: address,
      transactions: @transactions
    }
  end

  def create
    user_wallet = Wallet.new(wallet: @wallet.new_address.address, user_id: current_user.id)
    if user_wallet.save
      render json: {wallet: user_wallet }
    else
      render json: {message: "there was an error"}
    end
  end

  def send_money
    error = false # default

    recieve_address = User.find_by(id: params[:user_id]).wallet.wallet
    send_address    = current_user.wallet.wallet
    amount          = (params[:amount] * 100000000).to_i

    begin
      payment = @wallet.send(recieve_address, amount, {from_address: send_address})
    rescue Exception => e
      puts e.to_s
      error = true
      message = e.to_s
    end

    if error
      render json: {message: message}, status: 400
    else
      render json: {payment: payment.tx_hash}, status: 200
    end
  end

  def transfer_money
    error = false # default

    # recieve_address = User.find_by(id: params[:user_id]).wallet.wallet
    send_address    = current_user.wallet.wallet

    begin
      payment = @wallet.send('1CY7jZwp6d9JhZ9zZBZCLzztTp6LEYaoKk', params[:amount], {from_address: send_address})
    rescue Exception => e
      puts e.to_s
      case e.to_s
      when "No free outputs to spend"
        error = true
        message = "No free outputs to spend"
      else
        error = true
        message = "there is a error"
      end
    end

    if error
      render json: {message: message}, status: 400
    else
      render json: {payment: payment.tx_hash}, status: 200
    end
  end


  private

  def set_wallet
    @wallet = Blockchain::Wallet.new(ENV['BITCOIN_ID'], ENV['BITCOIN_PASSWORD'])
  end

  def set_user_wallet
    @user_wallet = current_user.wallet
    if @user_wallet.nil?
      render json: {message: "User don't have wallet yet"}
    end
  end
end
# 13bo34XTW9c8fpESDUXmanKsQF7rNF2uRr
# 1PxBb9U7F9UssBuW9nWWMxaLAgYdP3zUQ9
