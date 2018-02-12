RSpec.describe Pact::Message do
  it "has a version number" do
    expect(Pact::Message::VERSION).not_to be nil
  end
end
