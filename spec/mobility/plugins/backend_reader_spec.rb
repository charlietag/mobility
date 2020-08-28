require "spec_helper"
require "mobility/plugins/backend_reader"

describe Mobility::Plugins::BackendReader do
  include Helpers::Configure
  include Helpers::Backend

  context "with default format string" do
    configure do
      backend_reader
      backend :null
    end
    translates :title

    it "defines <attr>_backend methods mapping to backend instance for <attr>" do
      expect(instance.respond_to?(:title_backend)).to eq(true)
      expect(instance.title_backend).to eq(instance.mobility_backends[:title])
    end
  end

  context "with custom format string" do
    configure do
      backend_reader "%s_translations"
      backend :null
    end
    translates :title

    it "defines backend reader methods with custom format string" do
      expect(instance.respond_to?(:title_translations)).to eq(true)
      expect(instance.respond_to?(:title_backend)).to eq(false)
      expect(instance.title_translations).to eq(instance.mobility_backends[:title])
    end
  end

  context "with true as format string" do
    configure do
      backend_reader true
      backend :null
    end
    translates :title

    it "defines backend reader methods with default format string" do
      expect(instance.respond_to?(:title_backend)).to eq(true)
      expect(instance.title_backend).to eq(instance.mobility_backends[:title])
    end
  end

  context "with falsey format string" do
    configure do
      backend_reader false
      backend :null
    end
    translates :title

    it "does not define backend reader methods" do
      expect(instance.respond_to?(:title_backend)).to eq(false)
      expect { instance.title_backend }.to raise_error(NoMethodError)
    end
  end
end
