require 'spec_helper'

describe Git::Commit do
  it 'has a version number' do
    expect(Git::Commit::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
