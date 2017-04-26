class HomeController < ApplicationController
  before_action :verify_phone_number, only: :create
  def index
  end

  def create
    begin
      @amount = helpers.price(params[:sms][:dog_pictures].to_i)

      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => 'Cocoa.dog',
        :currency    => 'usd'
      )
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to action: :index
    end
    Message.send_sms(params[:sms][:phone_number], params[:sms][:message], params[:sms][:dog_pictures].to_i)
    flash[:success] = "Pictures have been sent successfully!"
    redirect_to action: :index
  end

  def verify_phone_number
    phone = Phonelib.parse(params[:sms][:phone_number])
    if phone.invalid_for_country? 'US'
      flash[:error] = 'Phone Number must be valid! You were not charged'
      redirect_to action: :index
    end
  end
end
