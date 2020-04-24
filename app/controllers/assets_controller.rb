class AssetsController < ActionController::Base
  include ApplicationHelper
  require 'xero-ruby'
  layout 'application'
  
  def assets
    asset = {
      "assetName": "AssetName: #{rand(10000)}",
      "assetNumber": "Asset: #{rand(10000)}",
      "assetStatus": "DRAFT"
    }
    @asset = xero_client.asset_api.create_asset(current_user.active_tenant_id, asset)
  end

end