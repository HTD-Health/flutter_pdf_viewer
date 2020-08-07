Pod::Spec.new do |s|
  s.name             = 'pdf_platform_view'
  s.version          = '0.5.0'
  s.summary          = 'Pdf viewer for ios and android.'
  s.description      = <<-DESC
  Pdf viewer for ios and android.
                       DESC
  s.homepage         = 'https://github.com/kamilklyta'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Kamil Klyta' => 'kamil.klyta@htdevelopers.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.framework        = 'WebKit'
  
  s.ios.deployment_target = '8.0'
end
