require 'spec_helper'
describe Git::Commit::Format::AngularJS::Validator do

  accepted_type_formats = [
      :feat,
      :fix,
      :docs,
      :style,
      :refactor,
      :perf,
      :test,
      :chore,
  ].freeze

  let(:git_commit_message) { '' }
  let(:instance) { described_class.new(git_commit_message) }

  describe '#validate_mandatory_type' do
    subject { instance.validate_mandatory_type }

    accepted_type_formats.each do |type_text|
      context "when the type is: #{type_text}" do

        let(:git_commit_message) do
          <<-GIT_COMMIT_MESSAGE
#{type_text}: hello wold
          GIT_COMMIT_MESSAGE
        end

        it { is_expect.to_not raise_error }

      end
    end

    context 'when the type is an invalid string' do

      let(:git_commit_message) do
        <<-GIT_COMMIT_MESSAGE
          invalid: hello wold
        GIT_COMMIT_MESSAGE
      end

      it { is_expect.to raise_error(Git::Commit::Format::Error, /^invalid type given in the commit: invalid/) }

    end

  end

  describe '#validate_mandatory_subject' do
    subject { instance.validate_mandatory_subject }

    context 'when a valid format given for the subject' do

      let(:git_commit_message) do
        <<-GIT_COMMIT_MESSAGE
          feat: hello wold
        GIT_COMMIT_MESSAGE
      end

      it { is_expect.to_not raise_error }

    end

    context 'when the message too short to be accepted' do

      context 'and body is not given' do
        let(:git_commit_message) do
          <<-GIT_COMMIT_MESSAGE
          feat:
          GIT_COMMIT_MESSAGE
        end

        it { is_expect.to raise_error(Git::Commit::Format::Error, 'missing subject from the commit!') }
      end

      context 'and body is given' do

        context 'and scope not given' do
          let(:git_commit_message) do
            <<-GIT_COMMIT_MESSAGE
          feat:

          body message
            GIT_COMMIT_MESSAGE
          end

          it { is_expect.to raise_error(Git::Commit::Format::Error, 'missing subject from the commit!') }
        end

        context 'and scope is given' do
          let(:git_commit_message){"feat(scope): \n\nbody line 1\nbody line 2\nbody line 3"}

          it { is_expect.to raise_error(Git::Commit::Format::Error, 'missing subject from the commit!') }
        end

      end



    end

    context 'when we not use the imperative, present tense: "change"' do

      %w(changed changes).each do |wrong_change_text_format|
        context "when we use for example: #{wrong_change_text_format}" do

          let(:git_commit_message) do
            <<-GIT_COMMIT_MESSAGE
              feat: #{wrong_change_text_format} db schema
            GIT_COMMIT_MESSAGE
          end

          it { is_expect.to raise_error(Git::Commit::Format::Error, 'use the imperative, present tense: "change" not "changed" nor "changes"') }

        end

      end

    end

    context 'when we use the imperative, present tense: "change"' do


      let(:git_commit_message) do
        <<-GIT_COMMIT_MESSAGE
          feat: change wold
        GIT_COMMIT_MESSAGE
      end

      it { is_expect.to_not raise_error }

    end

    context 'when first letter is capitalized' do

      let(:git_commit_message) do
        <<-GIT_COMMIT_MESSAGE
              feat: Change db schema
        GIT_COMMIT_MESSAGE
      end

      it { is_expect.to raise_error(Git::Commit::Format::Error, "Don't capitalize first letter") }

    end

    context 'when first letter is downcase' do

      let(:git_commit_message) do
        <<-GIT_COMMIT_MESSAGE
              feat: change db schema
        GIT_COMMIT_MESSAGE
      end

      it { is_expect.to_not raise_error }

    end

    context "when there is a dot in the subject's end" do

      let(:git_commit_message) do
        <<-GIT_COMMIT_MESSAGE
              feat: change db schema.
        GIT_COMMIT_MESSAGE
      end

      it { is_expect.to raise_error(Git::Commit::Format::Error, 'No dot (.) at the end') }

    end

  end

  describe '#validate_optional_scope' do
    subject { instance.validate_optional_scope }

    context 'when scope is given' do
      let(:scope) { '$root' }
      before { git_commit_message.concat("feat#{wrapped_scope}: sup?") }

      context 'and wrapped with ()' do
        let(:wrapped_scope) { "(#{scope})" }

        it { is_expect.to_not raise_error }

        context 'and the scope message is invalid because too short' do
          let(:scope) { '' }

          it { is_expect.to raise_error(Git::Commit::Format::Error, 'scope is too short!') }
        end
      end

      context 'and the bracer wrap is not correct' do
        let(:wrapped_scope) { "(#{scope}" }

        it { is_expect.to raise_error(Git::Commit::Format::Error, 'scope is malformed!') }
      end

    end
  end

  describe '#validate_optional_body' do
    subject { instance.validate_optional_body }
    before { git_commit_message.concat('feat(scope): subject') }
    let(:body) { 'body message' }

    context 'when it is placed after a blank line' do
      before { git_commit_message.concat("\n\n") }

      context 'and body is given' do
        before { git_commit_message.concat(body) }

        it { is_expect.to_not raise_error }
      end

      context 'and body is not given' do
        it { is_expect.to_not raise_error }
      end

    end

    context 'when it is placed right after the subject line' do
      before { git_commit_message.concat("\n") }

      context 'and body is given' do
        before { git_commit_message.concat(body) }

        it { is_expect.to raise_error(Git::Commit::Format::Error, 'body must be placed after a blank line!') }
      end

    end

  end

  # describe '#validate_optional_footer' do
  #   subject { instance.validate_optional_footer }
  #
  #   context 'message in the right format before the footer' do
  #     before do
  #       git_commit_message.concat("feat(scope): subject\n\nbody line 1\nbody line 2\nbody line 3")
  #     end
  #
  #     context 'and footer not given' do
  #       it { is_expect.to_not raise_error }
  #     end
  #
  #     context 'and there is a blank line after the body' do
  #       before{ git_commit_message.concat("\n\n") }
  #
  #       context 'and footer is given' do
  #         let(:footer){ 'some footer message' }
  #         before{ git_commit_message.concat(footer)}
  #
  #         context 'and there is no BREAKING CHANGE mentioned' do
  #           it { is_expect.to_not raise_error }
  #         end
  #
  #         context 'and there is a BREAKING CHANGE mentioned in downcase' do
  #           let(:footer){'breaking change: nope this is not valid'}
  #
  #           it { is_expect.to raise_error(Git::Commit::Format::Error,'breaking change should be upcase!')}
  #         end
  #
  #       end
  #
  #
  #     end
  #
  #   end
  #
  # end

end