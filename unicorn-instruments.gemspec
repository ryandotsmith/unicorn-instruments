#encoding: UTF-8
Gem::Specification.new do |s|
  s.name          = 'unicorn-instruments'
  s.email         = 'ryan@heroku.com'
  s.version       = '0.0.4'
  s.date          = '2013-03-14'
  s.description   = 'Prints ruby processing time to stdout.'
  s.summary       = 'Monkey patch to unicorn to instruments methods.'
  s.authors       = ['Ryan Smith (♠ ace hacker)']
  s.homepage      = 'http://github.com/ryandotsmith/unicorn-instruments'
  s.license       = 'MIT'
  s.files         = ['unicorn-instruments.rb']
  s.require_path  =  '.'
  s.add_dependency('unicorn', '4.6.2')
end
