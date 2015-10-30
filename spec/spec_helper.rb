$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'git/commit'

module RSpecHelpers

  def reset_object_from_mocks(object)
    RSpec::Mocks.space.proxy_for(object).reset
  end

  def is_expect
    expect { subject }
  end

end

RSpec.configure do |c|
  c.include(RSpecHelpers)
end