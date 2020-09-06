require "spec_helper"

return unless defined?(ActiveRecord)

describe "Mobility::Backends::ActiveRecord::Hstore", orm: :active_record, db: :postgres do
  require "mobility/backends/active_record/hstore"
  extend Helpers::ActiveRecord

  column_options = { column_prefix: 'my_', column_suffix: '_i18n' }
  column_affix = "#{column_options[:column_prefix]}%s#{column_options[:column_suffix]}"

  before { stub_const 'HstorePost', Class.new(ActiveRecord::Base) }

  context "with no plugins" do
    plugins {}
    include_backend_examples described_class, 'HstorePost', column_options
  end

  context "with basic plugins" do
    plugins :active_record, :reader, :writer
    let(:backend) { post.mobility_backends[:title] }

    before { translates HstorePost, :title, :content, backend: :hstore, **column_options }
    let(:post) { HstorePost.new }

    include_accessor_examples 'HstorePost'
    include_serialization_examples 'HstorePost', column_affix: column_affix
    include_dup_examples 'HstorePost'
    include_cache_key_examples 'HstorePost'

    describe "non-text values" do
      it "converts non-string types to strings when saving" do
        post = HstorePost.new
        backend = post.mobility_backends[:title]
        backend.write(:en, { foo: :bar } )
        post.save
        expect(post[column_affix % "title"]).to match_hash({ en: "{:foo=>:bar}" })
      end
    end
  end

  context "with query plugin" do
    plugins :active_record, :reader, :writer, :query
    let(:backend) { post.mobility_backends[:title] }

    before { translates HstorePost, :title, :content, backend: :hstore, **column_options }
    let(:post) { HstorePost.new }

    include_querying_examples 'HstorePost'
    include_validation_examples 'HstorePost'
  end

  context "with dirty plugin" do
    plugins :active_record, :reader, :writer, :dirty
    let(:backend) { post.mobility_backends[:title] }

    before { translates HstorePost, :title, :content, backend: :hstore, **column_options }
    let(:post) { HstorePost.new }

    include_accessor_examples 'HstorePost'
    include_serialization_examples 'HstorePost', column_affix: column_affix
  end
end
