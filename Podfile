# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Cya' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'Socket.IO-Client-Swift', '~> 12.0.0' # Or latest version
  pod 'Alamofire', '~> 4.5'
  pod 'youtube-ios-player-helper'
  pod 'MessageKit'
  
  pod 'Stripe'
  
  pod 'FBSDKCoreKit'
  pod 'FBSDKShareKit'
  pod 'FBSDKLoginKit'
  
  pod 'Firebase/Auth'
  pod 'GoogleSignIn'
  
  pod 'libjingle_peerconnection'
  pod 'SDWebImage'
  
end

post_install do |installer|
    copy_pods_resources_path = "Pods/Target Support Files/Pods-Cya/Pods-Cya-resources.sh"
    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
    text = File.read(copy_pods_resources_path)
    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
end
