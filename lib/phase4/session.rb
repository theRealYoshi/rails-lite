require 'json'
require 'webrick'
require 'byebug'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      cookie = req.cookies.find {|cookie| cookie.name == "_rails_lite_app" }
      if cookie
        @the_hash = JSON.parse(cookie.value)
      else
        @the_hash = {}
      end
    end

    def [](key)
      @the_hash[key]
    end

    def []=(key, val)
      @the_hash[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      cookie = WEBrick::Cookie.new('_rails_lite_app', @the_hash.to_json)
      res.cookies << cookie
    end
  end
end
