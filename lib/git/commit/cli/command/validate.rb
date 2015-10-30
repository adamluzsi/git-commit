class Git::Commit::CLI::Command::Validate < Git::Commit::CLI::Command

  class_description 'Validate Commit message or commit file content'

  desc 'angularjs <git commit message or file path>',
       'validate commit message or file content by angularjs commit conventions'

  def angularjs_format(commit_message)

    commit_message = File.read(commit_message) if File.exists?(commit_message)

    begin
      Git::Commit::Format::AngularJS::Validator.new(commit_message).validate
    rescue Git::Commit::Format::Error => ex
      $stderr.puts(ex.message,"\n",commit_message)
      exit(1)
    end

  end

end