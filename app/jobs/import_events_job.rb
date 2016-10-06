class ImportEventsJob < ApplicationJob
  queue_as :default

  def perform page
      page.send :import
  end
end
