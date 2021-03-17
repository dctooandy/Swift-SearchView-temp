platform :ios, '10.0'

def shared_pods
  
  pod 'RxSwift',    '~> 4.0'
  pod 'RxCocoa',    '~> 4.0'
  pod 'Alamofire',    '<= 4.9.1'
  pod 'SnapKit', '~> 4.0.0'
  pod 'Kingfisher', '~> 5.7.1'
  pod 'SwiftyBeaver'
  pod 'lottie-ios'
  pod 'Toaster', :git => 'https://github.com/devxoul/Toaster.git', :branch => 'master'

end

target 'Swift-SearchGitHub' do
  use_frameworks!
  shared_pods

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
    end
  end
end
