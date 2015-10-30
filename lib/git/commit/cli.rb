require 'thor'
class Git::Commit::CLI < Thor

  require 'git/commit/cli/command'

  ObjectSpace.each_object(Class).select { |klass| klass < Git::Commit::CLI::Command }.each do |command|

    subcommand_name = command.to_s.split('::').last.downcase
    desc("#{subcommand_name} [COMMAND]",command.get_class_description)
    subcommand(subcommand_name, command)

  end

end