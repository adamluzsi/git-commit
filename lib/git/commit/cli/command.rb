class Git::Commit::CLI::Command < Thor

  class << self

    def get_class_description
      @class_description
    end

    protected

    def class_description(description)
      @class_description = description
    end

  end

  require 'git/commit/cli/command/validate'

end