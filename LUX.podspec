#
# Be sure to run `pod lib lint LUX.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LUX'
    s.version          = '0.1.0'
    s.summary          = 'LUX contains everything you need to create a simple app.'

    s.description      = <<-DESC
  There's a bunch of really cool stuff in this pod, all targeted at letting you build the things that are *different* about your app, not the reproducing the same things over and over. Customizable, extendable, bare bones implementations of common UX components like splash, login, creds creation, commenting, and view/edit profile screens, an app delegate implementation that sets up fabric and crashlytics for you, a simple framework for handling user sessions, a material design based controller for table views... and more coming!
                         DESC

    s.homepage         = 'https://github.com/ThryvInc/LUX'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Elliot' => '' }
  s.source           = { :git => 'https://github.com/ThryvInc/LUX.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/elliot_schrock'

  s.ios.deployment_target = '13.0'

  s.source_files = 'LUX/Classes/**/*.swift'
  s.resources = 'LUX/**/*.xib'
  
  s.subspec 'Utilities' do |sp|
    sp.source_files = 'LUX/Classes/Utilities/**/*.swift'
    sp.resources = 'LUX/Classes/Utilities/**/*.xib'
    sp.dependency 'Prelude', '~> 3.0'
  end
  
  s.subspec 'Auth' do |sp|
    sp.source_files = 'LUX/Classes/Auth/**/*.swift'
    sp.resources = 'LUX/Classes/Auth/**/*.xib'
  end
  
  s.subspec 'Networking' do |sp|
    sp.source_files = 'LUX/Classes/Networking/**/*.swift'
    sp.resources = 'LUX/Classes/Networking/**/*.xib'
    
    sp.dependency 'FunNet'
    sp.dependency 'LUX/Auth'
    sp.dependency 'LUX/Utilities'
  end
  
  s.subspec 'TableViews' do |sp|
    sp.source_files = 'LUX/Classes/TableViews/**/*.swift'
    sp.resources = 'LUX/Classes/TableViews/**/*.xib'
    
    sp.dependency 'LUX/Networking'
    sp.dependency 'MultiModelTableViewDataSource'
  end
  
  s.subspec 'AppOpenFlow' do |sp|
    sp.source_files = 'LUX/Classes/AppOpenFlow/**/*.swift'
    sp.resources = 'LUX/Classes/AppOpenFlow/**/*.xib'
    
    sp.dependency 'LUX/Auth'
    sp.dependency 'LUX/Networking'
  end
  
  s.subspec 'Search' do |sp|
    sp.source_files = 'LUX/Classes/Search/**/*.swift'
    sp.resources = 'LUX/Classes/Search/**/*.xib'
    
    sp.dependency 'LUX/TableViews'
  end

  s.dependency 'ISO8601DateFormatter'
  #s.dependency 'SBTextInputView'
  
end
