if defined?(Rails::Server)
  SyncEventsJob.perform_later
end