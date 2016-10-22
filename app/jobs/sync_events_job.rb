class SyncEventsJob < ApplicationJob
  queue_as :default

  def perform
      Event.delete_expired
      Page.all.map(&:import)
      SyncEventsJob.set(wait: 5.hours).perform_later
  end
end
