require 'sorting_helper'

# Get the order params and order the column by this
#TODO: support multiple consecutive order parameters

module SortableFind
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do 
      class << self
        VALID_FIND_OPTIONS << :sort
        alias_method_chain :find, :sorting
      end
    end
  end
  
  module ClassMethods
    def find_with_sorting(*args)
      options = if args.respond_to?(:extract_options!)
        args.extract_options!
      else
        extract_options_from_args!(args)
      end
      sort_parameter = options.delete(:sort) || nil
      if sort_parameter
        # The :sort option was specified
        sortcolumn = sort_parameter.downcase
        if sortcolumn =~ /^([a-z_]+)_inverted$/
          sortorder = 'DESC'
        elsif sortcolumn =~ /^([a-z_]+)?$/
          sortorder = 'ASC'
        else
          raise _('Invalid Column Format')
        end
        # TODO: check if you can do class.instance instead of class.new to save memory
        if self.new.respond_to?($1)
          sortcolumn = $1
        else
          raise _('Invalid Column Name')
        end
        
        options[:order] = (sortcolumn && sortorder ? "#{sortcolumn} #{sortorder}" : nil)
    
        find_without_sorting(*(args << options))
      else
        # The :sort option was not specified, so go on with the regular Base.find
        find_without_sorting(*(args << options))
      end
    end
  end
  
end