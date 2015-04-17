Gem::Specification.new do |s|
  s.name        = 'ig-crypto-utils'
  s.version     = '0.0.1'
  s.date        = '2015-02-18'
  s.summary     = 'AES and EDCSA utils based on OpenSSL'
  s.description = 'AES and EDCSA utils based on OpenSSL'
  s.authors     = ['Infinity-G']
  s.email       = 'developer@infinity-g.com'
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.homepage    = ''
  s.license     = 'MIT'
end

# run 'gem build ig-crypto-utils' to create gem
# run