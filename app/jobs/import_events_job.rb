class ImportEventsJob < ApplicationJob
  queue_as :default

  def perform page = nil
    return unless page
    
    pages = page.is_a?(Array) ? page : [page]
    pages.map { |pg|  
      pg.send :import 
    }
  end
end
