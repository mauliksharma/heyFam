platform :ios, '9.0'

target 'heyFam' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for heyFam

pod 'Firebase'
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Storage'
pod 'Firebase/Database'
pod 'SVProgressHUD'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end


