# Accepted AngularJS commit format
#
# <type>(<scope>): <subject>
# <BLANK LINE>
# <body>
# <BLANK LINE>
# <footer>
class Git::Commit::Format::AngularJS::Validator

  def validate
    validate_mandatory_type
    validate_mandatory_subject
    validate_optional_scope
    validate_optional_body
  end

  def validate_mandatory_type

    types = fetch_by(/^(\w+)/)[0]

    if types.empty?
      raise_format_error('missing type from the commit!')
    end

    type_sym = types.first.to_sym
    unless Git::Commit::Format::AngularJS::TYPES.keys.include?(type_sym)
      raise_format_error(
          "invalid type given in the commit: #{type_sym}",
          "use the following types: \n#{Git::Commit::Format::AngularJS.type_help_text}"
      )
    end

  end

  def validate_mandatory_subject

    subjects = @commit_message.to_s.split("\n")[0].scan(/^[^:]+:\s+(.*?)$/)[0]

    if subjects.nil? or [*subjects].select{|str| not str.to_s.empty? }.empty?
      raise_format_error('missing subject from the commit!')
    end

    subject = subjects[0]
    if subject =~ /\b(changed|changes)\b/i
      raise_format_error('use the imperative, present tense: "change" not "changed" nor "changes"')
    end

    if subject =~ /^[A-Z]\w*/
      raise_format_error("Don't capitalize first letter")
    end

    if subject =~ /\.\s*$/
      raise_format_error('No dot (.) at the end')
    end

  end

  def validate_optional_scope

    scope_begins = fetch_by(/^\w+(\()/)

    if not scope_begins.empty? and not scope_begins[0].empty? and scope_content.nil?
      raise_format_error('scope is malformed!')
    end

    first_line_scope_strs = scope_content

    return if first_line_scope_strs.nil?

    scope_str = first_line_scope_strs[0]
    if not scope_str.nil? and scope_str.to_s.length == 0
      raise_format_error('scope is too short!')
    end

  end


  def validate_optional_body

    body_content_lines = fetch_by(/^.*$/)[1..-1].select { |str| !(str =~ /^\s*$/) }
    given_a_blank_line = @commit_message.split("\n")[1].to_s.empty?

    if not given_a_blank_line and not body_content_lines.empty?
      raise_format_error('body must be placed after a blank line!')
    end

  end

  def validate_optional_footer
  end

  protected

  def initialize(commit_message)
    @commit_message = commit_message.to_s.dup.strip
  end

  def fetch_by(regular_expression)
    @commit_message.scan(regular_expression)
  end

  def raise_format_error(*messages)
    raise(Git::Commit::Format::Error, messages.join("\n"))
  end

  private

  def scope_content
    fetch_by(/^\w+\(([^\)]*)\)/)[0]
  end

end
