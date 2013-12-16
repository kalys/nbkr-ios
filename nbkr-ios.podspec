Pod::Spec.new do |s|
  s.name         = "nbkr-ios"
  s.version      = "0.0.1"
  s.summary      = "API consumer for currency rates of National Bank of Kyrgyz Republic."
  s.description  = <<-DESC
                   API consumer for currency rates of National Bank of Kyrgyz Republic.
                   * http://www.nbkr.kg/XML/daily.xml
                   * http://www.nbkr.kg/XML/weekly.xml
                   DESC
  s.homepage     = "http://github.com/kalys/nbkr-ios"
  s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license      = 'MIT'
  s.author       = { "Kalys Osmonov" => "kalys@osmonov.com" }
  s.source       = { :git => "https://github.com/kalys/nbkr-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '5.0'
  s.ios.deployment_target = '5.0'
  s.requires_arc = true

  s.source_files = 'Classes'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
end
