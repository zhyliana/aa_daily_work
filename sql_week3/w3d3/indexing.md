# Indexing

## Index Foreign Keys

Proper indexing is very important for fast table lookup. If we lookup
values without an index, we may have to read every row.

Consider the following example:

```ruby
class User < ActiveRecord::Base
  has_many :conversations
end
  
class Conversation < ActiveRecord::Base
  belongs_to :user
end   
```

Given a `Conversation`, we can quickly lookup a `User` because
ActiveRecord automatically creates an index on `users`' primary key,
`id`. But what about `user.conversations`?

ActiveRecord won't automatically index `conversations` by the
`user_id` column. So the generated query (`SELECT * FROM conversations
WHERE user_id = ?`) will require a full table scan and look at every
`conversations` row to check the `user_id`. With a lot of
conversations, that becomes dog slow.

The solution is to ask ActiveRecord to make an index for us:

```ruby
class AddUserIdIndexToConversations < ActiveRecord::Migration
  def change
    add_index :conversations, :user_id
  end
end
```

That's all! Run the migration and the index will be built and future
queries based on `user_id` will be much accelerated.

You can read a little more on indexing [here][tomafro-indexing].

[tomafro-indexing]: http://tomafro.net/2009/08/using-indexes-in-rails-index-your-associations
