class OrderItemsController < ApplicationController
	def create
	    @order = current_order
	    @order.user = current_user
	    @order.restaurant_id = session[:restaurant_id]
	    @order_item = @order.order_items.new(order_item_params)

	    @user_address = current_location
		@resto_rate = TariffRate.resto_rate(@user_address.distance_from_user).first
		@order.min_order = @resto_rate.min_order

	    respond_to do |format|
	    	if !@order.order_items.exists?(menu_id: params[:order_item][:menu_id], order_id: @order.id)
	    		@order.save
		    else
		    	menu_item = @order.order_items.where(menu_id: params[:order_item][:menu_id], order_id: @order.id).first
		    	menu_item.quantity += 1
		    	menu_item.save
		    end

		    session[:order_id] = @order.id
		    session[:restaurant_id] = @order.restaurant_id
		    @order = current_order
	      	format.js
	    end	
	end

	def update
	    @order = current_order
	    @order_item = @order.order_items.find(params[:id])

	    respond_to do |format|
	      if @order_item.update_attributes(order_item_params)
	        format.html { redirect_to @order_item, notice: 'order was successfully created.' }
	      else
	        format.html { render :new }
	        format.json { render json: @order_item.errors, status: :unprocessable_entity }
	      end
	      format.js
	     end
	end

	def destroy
	    @order = current_order
	    @order_item = @order.order_items.find(params[:id])
	    
	    respond_to do |format|
	    	if @order_item.destroy
	    	end
	    	format.js
	    end
	    @current_order = current_order
	end

	private
	  def order_item_params
	    params.require(:order_item).permit(:quantity, :menu_id)
	  end

	  def order_params
	    params.require(:order).permit(:user_id)
	  end

end
