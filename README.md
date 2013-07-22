# ScopeComposer

```ruby
class Example

  include ScopeComposer::Model

  scope_composer_for :search

  search_helper :integer, ->(v){ v.to_s.to_i }

  search_scope :limit
  search_scope :offset, ->(i){ where(offset: integer(i) ) }

  search_helper :find, ->(id){ Example.where(self.attributes).find(id) }

  def self.where(attrs)
    puts "where: #{attrs.to_param}"
    self
  end

  def self.find(id)
    puts "find by #{id}"
    self.new
  end

end

Example.limit(10).offset('50').find(10)
Example.limit(10).offset('50').to_param

scope = Example.limit(10)
scope.offset(20)
scope.find(2)

```

```
where: limit=10&offset=50
find by 10
Example:0x007ff8eb8ce920
```
