# Restful::Jsonapi

A temporary monkeypatch for JSONAPI support, both in request payload, and serializing the type without a namespace.

[![Gem Version](https://badge.fury.io/rb/restful-jsonapi.svg)](http://badge.fury.io/rb/restful-jsonapi)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'restful-jsonapi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install restful-jsonapi

## Usage

```
class MovieTypesController < ApplicationController

  ...
 
  private

  def movie_type_params
    restify_param(:movie_type).require(:movie_type).permit(
      :id,
      :name,
      created_user: [
        :id,
        :email
      ]
    )
  end
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/restful-jsonapi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
