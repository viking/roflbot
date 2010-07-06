# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{roflbot}
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Stephens"]
  s.date = %q{2010-07-06}
  s.default_executable = %q{roflbot}
  s.description = %q{roflbot will make you a rofl waffle}
  s.email = %q{viking415@gmail.com}
  s.executables = ["roflbot"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README",
     "Rakefile",
     "VERSION",
     "bin/roflbot",
     "lib/roflbot.rb",
     "lib/roflbot/base.rb",
     "lib/roflbot/runner.rb",
     "lib/roflbot/sentence.tt",
     "lib/roflbot/sentence_bot.rb",
     "roflbot.gemspec",
     "test/fixtures/bogus.yml",
     "test/helper.rb",
     "test/roflbot/test_base.rb",
     "test/roflbot/test_runner.rb",
     "test/roflbot/test_sentence_bot.rb"
  ]
  s.homepage = %q{http://github.com/viking/roflbot}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{roflbot is a bot that says stuff on AIM and Twitter}
  s.test_files = [
    "test/helper.rb",
     "test/roflbot/test_sentence_bot.rb",
     "test/roflbot/test_runner.rb",
     "test/roflbot/test_base.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<net-toc>, [">= 0"])
      s.add_runtime_dependency(%q<treetop>, [">= 0"])
      s.add_runtime_dependency(%q<twitter>, [">= 0"])
    else
      s.add_dependency(%q<net-toc>, [">= 0"])
      s.add_dependency(%q<treetop>, [">= 0"])
      s.add_dependency(%q<twitter>, [">= 0"])
    end
  else
    s.add_dependency(%q<net-toc>, [">= 0"])
    s.add_dependency(%q<treetop>, [">= 0"])
    s.add_dependency(%q<twitter>, [">= 0"])
  end
end

