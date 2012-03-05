require 'spec_helper'

describe JsonHelper do
  context "#json" do
    let(:property) { "prop" }
    let(:value)    { "<script>val</script>"  }
    subject { helper.json({ property => value }) }

    it "renders json" do
      should include(%{"#{property}":})
    end

    it "returns html safe content" do
      should be_html_safe
    end

    it "escapes script closing tags" do
      should_not include("</script>")
      should include(%{</script"+">})
    end
  end
end
