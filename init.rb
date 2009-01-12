ActiveRecord::Base.send(:include, SortableFind)
ActionView::Base.send(:include, SortableFind::Helpers)