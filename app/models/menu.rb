class Menu < ApplicationRecord
	belongs_to :restaurant
	belongs_to :menu_category
	has_many :menu_add_ons
	has_many :order_items

	before_save :compute_total_price

	validates :name, presence: true
	validates :price, presence: true, numericality: true

	mount_uploader :image, MenuImageUploader

	scope :resto_menus, -> (resto_id) { joins(:menu_category).where( restaurant_id: resto_id, active: true ) }
	# scope :resto_menus, -> (resto_id) { joins("INNER JOIN menu_categories ON menus.menu_category_id = menu_categories.id").select("menu_categories.*") }

	# scope :resto_menus, -> (resto_id) { joins(:menu_category ).select('menus.* , menu_categories.*') }

	private

		def compute_total_price
			self[:total_price] = price + (price * (commission / 100))
		end
end
