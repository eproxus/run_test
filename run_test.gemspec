Gem::Specification.new do |gem|
  # Info
  gem.name                  = "run_test"
  gem.version               = "0.1.1"
  gem.summary               = "A simple but smart test runner for Ruby"
  gem.description           = <<-eos
    `run_test` is a simple but smart test runner for Ruby.

    It helps you find your tests given almost any input. 
  eos
  gem.authors               = ["Adam Lindberg"]
  gem.email                 = "hello@alind.io"
  gem.homepage              = "https://github.com/eproxus/run_test"

  gem.files                 = `git ls-files`.split("\n")
  gem.executables           = `git ls-files -- bin/*`.split("\n").map do |f|
                                File.basename(f)
                              end
  gem.require_paths         = ["lib"]
  gem.required_ruby_version = ">= 1.9"
end
