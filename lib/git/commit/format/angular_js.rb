module Git::Commit::Format::AngularJS

  TYPES = {
      feat: 'A new feature',
      fix: 'A bug fix',
      docs: 'Documentation only changes',
      style: 'Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)',
      refactor: 'A code change that neither fixes a bug nor adds a feature',
      perf: 'A code change that improves performance',
      test: 'Adding missing tests',
      chore: 'Changes to the build process or auxiliary tools and libraries such as documentation generation'
  }

  SCOPE = 'The scope could be anything specifying place of the commit change.'

  require 'git/commit/format/angular_js/builder'
  require 'git/commit/format/angular_js/validator'

  def self.type_help_text
    TYPES.map{|k,v| "\t#{k}:\t#{v}" }.join("\n")
  end

end