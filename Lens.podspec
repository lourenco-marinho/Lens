#
# Be sure to run `pod lib lint ActionButton.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Lens"
  s.version          = "0.3"
  s.summary          = "Lens is a very simple yet elegant query builder made in Swift to work with CoreData."
  s.homepage         = "https://github.com/lourenco-marinho/Lens"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Lourenço Marinho" => "lourenco.pmarinho@gmail.com" }
  s.source           = { :git => "https://github.com/lourenco-marinho/Lens.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/lopima'

  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Source/*.swift'
end
