require_relative '../../test_helper'
describe Formatifier do
  it "must be defined" do
    Formatifier::VERSION.wont_be_nil
  end
end
