class ChargesController < ApplicationController
  before_action :authenticate_user!


  def create
    begin
      @order = Order.find(session[:order_id])
      # Amount in cents
      @amount = @order.order_total * 100

      customer = Stripe::Customer.create(
        email: params[:stripeEmail],
        source: params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        customer: current_user.id,
        amount: @amount,
        description: 'Rails Stripe customer',
        currency: 'usd'
      )

      @order.status = 'paid'

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path

  end
end
