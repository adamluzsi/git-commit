# Git::Commit

Git commit helper to have easy use with formats such as AngularJS change log format.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'git-commit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-commit

## Usage

```
git.commit help
Commands:
  git.commit help [COMMAND]      # Describe available commands or one specific command
  git.commit validate [COMMAND]  # Validate Commit message or commit file content
  git.commit validate angularjs <git commit message or file path>  # validate commit message or file content by angularjs commit conventions
```

I use this for enfoce angularJS git commit convention in commit-msg hook 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/git-commit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

