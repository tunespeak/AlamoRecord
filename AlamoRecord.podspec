
Pod::Spec.new do |s|
  s.name             = 'AlamoRecord'
  s.version          = '1.3.1'
  s.summary          = 'An elegant Alamofire wrapper inspired by ActiveRecord.'
  s.description      = <<-DESC
AlamoRecord is a powerful yet simple framework that eliminates the often complex networking layer that exists between your networking framework and your application. AlamoRecord uses the power of AlamoFire, AlamofireObjectMapper and the concepts behind the ActiveRecord pattern to create a networking layer that makes interacting with your API easier than ever.
                       DESC

  s.homepage         = 'https://github.com/tunespeak/AlamoRecord'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tunespeak' => 'daltonhint4@gmail.com' }
  s.source           = { :git => 'https://github.com/tunespeak/AlamoRecord.git', :tag => s.version.to_s }
  s.swift_version = '4.2'

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'AlamoRecord/Classes/**/*'
  s.dependency 'AlamofireObjectMapper', '~> 5.1'
end
