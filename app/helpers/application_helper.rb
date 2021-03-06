module ApplicationHelper
  require 'jwt'

  def token_expired
    token_expiry = Time.at(access_token['exp'])
    exp_text = time_ago_in_words(token_expiry)
    token_expiry > Time.now ? "in #{exp_text}" : "#{exp_text} ago" 
  end

  def id_token
    JWT.decode(current_user.token_set['id_token'], nil, false)[0] if current_user && current_user.token_set
  end

  def access_token
    JWT.decode(current_user.token_set['access_token'], nil, false)[0] if current_user && current_user.token_set
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def xero_client
    creds = {
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET'],
      redirect_uri: ENV['REDIRECT_URI'],
      scopes: ENV['SCOPES']
    }
    @xero_client ||= XeroRuby::ApiClient.new(credentials: creds)

    return @xero_client
  end

  def has_token_set?
    unless current_user && current_user.token_set
      redirect_to authorization_url
      return
    end
  end

  def authorization_url
    @authorization_url ||= xero_client.authorization_url 
  end

  def latest_connection(connections)
    if connections.length
      connections.sort { |a,b|
        DateTime.parse(a['createdDateUtc']) <=> DateTime.parse(b['createdDateUtc'])
      }.first['tenantId']
    else
      nil
    end
  end
end
