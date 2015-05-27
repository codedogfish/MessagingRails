class TestController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def show
  	require "rubygems"
	require "bunny"

	conn = Bunny.new
	conn.start

	ch = conn.create_channel
	q  = ch.queue("bunny.examples.hello_world", :auto_delete => false)
	x  = ch.default_exchange

	q.subscribe do |delivery_info, metadata, payload|
	  puts "Received #{payload}"
	end

	x.publish("Hello!", :routing_key => q.name)

	sleep 1.0
	conn.close
  end
end