desc 'Generate change log'
task :generate_changelog do
  require 'conventional_changelog'
  require 'pact/message/version'
  ConventionalChangelog::Generator.new.generate! version: "v#{Pact::Message::VERSION}"
end

desc 'Tag for release'
task :tag_for_release do | t, args |
  require 'pact/message/version'
  version = Pact::Message::VERSION
  command = "git tag -a v#{version} -m \"chore(release): version #{version}\" && git push origin v#{version}"
  puts command
  puts `#{command}`
end
