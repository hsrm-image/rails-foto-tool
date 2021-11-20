json.extract! comment, :id, :text, :username, :created_at, :updated_at
json.url comment_url(comment, format: :json)
