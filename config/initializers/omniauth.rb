# Replace API_KEY and API_SECRET with the values you got from Twitter
Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, ENV["API_KEY"], ENV["API_SECRET"]

  end