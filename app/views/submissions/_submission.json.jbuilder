json.extract! submission, :id, :title, :content, :user_id, :created_at, :updated_at
json.url submission_url(submission, format: :json)
