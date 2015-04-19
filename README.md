# LeanTag

## Introduction
Most Rails tagging frameworks are either outdated or large and complex. This gem seems to fill in the gap and provide a modern, lightweight tagging framework.


## History
1.0.0: Initial release


## Getting started
1. Generate the tag migrations using `rake lean_tag:install:migrations`
2. Add `include LeanTag::Taggable` to any classes you want to be able to tag.
