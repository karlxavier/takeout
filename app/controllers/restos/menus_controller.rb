class Restos::MenusController < ApplicationController
	before_action :authenticate_resto!
	before_action :set_restaurant

	def index
		@menus = Menu.all_resto_menus(@restaurant.id)
	end

	def new
		@menu = Menu.new
	end

	def create
		@menu = Menu.new(menu_params)
		@menu.restaurant = @restaurant
		@menu.commission = @restaurant.commission_percentage

		if @menu.save
			redirect_to restos_restaurant_menus_path(@restaurant)
		else
			render :new
		end
	end

	def edit
		@menu = Menu.find(params[:id])
	end

	def update
		@menu = Menu.find(params[:id])
		if @menu.update_attributes(menu_params)
			redirect_to restos_restaurant_menus_path(@restaurant)
		else
			render :edit
		end
	end

	private

		def set_restaurant
			@restaurant = Restaurant.find(current_resto.restaurant_id)
		end

		def menu_params
			params.require(:menu).permit(:name, :description, :price, :active, :menu_category_id, :image)
		end

end
