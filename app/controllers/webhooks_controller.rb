class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    secret = ENV['STRIPE_WEBHOOK_SECRET_KEY']

    event = nil

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, secret)
    rescue JSON::ParserError
      render json: { error: 'Invalid payload' }, status: 400 and return
    rescue Stripe::SignatureVerificationError
      render json: { error: 'Invalid signature' }, status: 400 and return
    end

    case event['type']
    when 'checkout.session.completed'
      session = event['data']['object']
      handle_checkout_completed(session)
    end

    render json: { message: 'success' }, status: 200
  end

  private

  def handle_checkout_completed(session)
    order = Order.find_by(stripe_session_id: session.id)
    return unless order

    order.update(
      paid: true,
      stripe_payment_id: session.payment_intent
    )
  end
end
