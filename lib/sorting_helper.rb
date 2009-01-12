module SortableFind
	module Helpers
		DEFAULT_OPTIONS = { :order_param => :order }

		# Generate a link to sort an html table
		def sortable_table_header(column, options = {})
			text = options[:text] || column.to_s
			order_param = options[:order_param] || DEFAULT_OPTIONS[:order_param]
			order = request.parameters[order_param.to_sym] == column.to_s ? "#{column}_inverted" : column
			link_to(text, request.parameters.merge(order_param.to_sym => order))
		end
	end
end