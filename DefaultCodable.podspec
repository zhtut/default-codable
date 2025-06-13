Pod::Spec.new do |s|
  s.name             = 'DefaultCodable'
  s.version          = '1.0.0'
  s.summary          = 'A Swift library providing @Default property wrapper for robust Codable decoding with default values.'

  s.description      = <<-DESC
DefaultCodable is a Swift library that enhances Codable types with @Default property wrapper. 
When JSON data contains type mismatches, it automatically provides default values instead of failing the entire decoding process.
                       DESC

  s.homepage         = 'https://github.com/yourusername/default-codable'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhtut' => 'zhtg@icloud.com' }
  s.source           = { :git => 'https://github.com/zhtut/default-codable.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.13'
  s.watchos.deployment_target = '4.0'
  s.tvos.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/DefaultCodable/**/*.swift'
  
  s.frameworks = 'Foundation'
  
  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/DefaultCodableTests/**/*.swift'
    test_spec.requires_app_host = false
  end
end
