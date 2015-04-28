# LeanTag

## Introduction
Most Rails tagging frameworks are either outdated or large and complex. This gem seems to fill in the gap and provide a modern, lightweight tagging framework.


## History
0.1.0: Initial release
1.0.0: Support for multiple tag fields on a single model


## Setup
1. Install the gem: `gem install lean_tag`
2. Generate the tag migrations using `rake lean_tag:install:migrations`
3. Run the migrations `rake db:migrate`


## Usage
Tags are accessible through a has_many associations `tags` on records. There is an eager-loading scope method called `with_tags` which you can use to optimise calls.

Given a simple class such as this:

```
class Product < ActiveRecord::Base
  extend LeanTag::Taggable
  taggable_on :tags
end
```

Most basically, you can manipulate tags in the following way:

```
@product = Product.new

# This will create tags, but won't persist until the product is saved
@product.tag_list = "red,sale"
@product.reload
@product.tag_list
 => ""

# Tags are persisted when the product is saved save
@product.tag_list = "red,sale"
@product.save
@product.tag_list
 => "red,sale"
```

Tags are just a simple has_many relationship, so you can also do the following:
```
@product.tags << LeanTag::Tag.first
```

There are also a number of convenience methods for manipulating tags:
```
@product.add_tag "test"  # change won't be persisted until the product is saved
@product.add_tag! "test"  # change will be persisted immediately

@product.remove_tag "test"  # change won't be persisted until the product is saved
@product.remove_tag! "test"  # change will be persisted immediately
```
