WickedPdf.config ||= {}
# 允許 wkhtmltopdf 存取本機檔案，以及設定 asset_host 以載入靜態資源
WickedPdf.config[:enable_local_file_access] = true
WickedPdf.config[:asset_host] = 'http://127.0.0.1:3000'# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join("node_modules/@fortawesome/fontawesome-free/webfonts")

# Add custom font assets path
Rails.application.config.assets.paths << Rails.root.join("app/assets/fonts")

# Precompile custom font files
Rails.application.config.assets.precompile += %w(
  NotoSansTC-Regular.ttf
  NotoSansTC-Bold.ttf
)
