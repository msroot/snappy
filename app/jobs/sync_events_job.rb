class SyncEventsJob < ApplicationJob
  queue_as :default

  def perform
      Event.delete_expired
      Page.all.map(&:import)
      SyncEventsJob.set(wait: 1.day).perform_later
  end
end
