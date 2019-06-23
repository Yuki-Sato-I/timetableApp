# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'newTableTimeApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for newTableTimeApp
  pod 'lottie-ios'
  pod 'Cosmos'
end

post_install do | installer |
  require 'fileutils'
  
  #Pods-acknowledgements.plist下記の場所に移動（2015/10/15）
  FileUtils.cp_r('Pods/Target Support Files/Pods-newTableTimeApp/Pods-newTableTimeApp-Acknowledgements.plist', 'newTableTimeApp/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
  
  # エラー
  #FileUtils.cp_r('Pods/Pods-acknowledgements.plist', 'newTableTimeApp/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
  
  end