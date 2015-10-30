Git = Module.new unless defined?(Git)
module Git::Commit

  require 'git/commit/version'
  require 'git/commit/format'
  require 'git/commit/cli'

end