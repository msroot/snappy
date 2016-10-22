json.extract! event, :id, :description, :name, :start_time, :end_time, :page_id, :cover_url, :fb_id, :created_at, :updated_at
json.url event_url(event, format: :json)