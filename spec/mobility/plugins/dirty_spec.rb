require "spec_helper"
require "mobility/plugins/dirty"

describe Mobility::Plugins::Dirty do
  include Helpers::Plugins

  plugin_setup

  context "dirty default option" do
    configure do
      dirty
    end

    it "requires fallthrough_accessors" do
      expect(attributes).to have_plugin(:fallthrough_accessors)
    end
  end

  context "fallthrough accessors is falsey" do
    configure do
      dirty true
      fallthrough_accessors false
    end

    it "emits warning" do
      expect { instance }.to output(
        /The Dirty plugin depends on Fallthrough Accessors being enabled,/
      ).to_stderr
    end
  end
end
