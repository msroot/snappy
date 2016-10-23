class SyncEventsJob < ApplicationJob
  queue_as :default

  def perform
    Sidekiq::ScheduledSet.new.clear
    Event.delete_expired
    Page.all.map(&:import)
    SyncEventsJob.set(wait: 5.hours).perform_later
  end

end
