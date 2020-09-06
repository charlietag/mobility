class Post < ActiveRecord::Base
  extend Mobility
  translates :title, backend: :key_value, cache: true, dirty: true, type: :string, attribute_methods: true
  translates :content, backend: :key_value, cache: true, dirty: true, type: :text, attribute_methods: true
end

class FallbackPost < ActiveRecord::Base
  self.table_name = "posts"
  extend Mobility
  translates :title, :content, backend: :key_value, type: :text, cache: true, dirty: true, fallbacks: true
end
