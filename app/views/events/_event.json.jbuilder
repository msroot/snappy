json.extract! event, :id,  :name, :description, :start_time, :end_time, :cover_url, :fb_id, :place

# if event.place.location.present?
# 	json.location event.place.location
# end
