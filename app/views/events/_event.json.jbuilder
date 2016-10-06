json.extract! event, :id, :description, :name, :start_time, :end_time, :page_id, :place_id, :fb_id, :created_at, :updated_at
json.url event_url(event, format: :json)