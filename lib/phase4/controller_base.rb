require_relative '../phase3/controller_base'
require_relative './session'
require_relative '../phase7/flash'
require 'byebug'

module Phase4
  class ControllerBase < Phase3::ControllerBase
    def redirect_to(url)
      raise "Redirect Double Render" if already_built_response?
      @res.header['location'] = url
      @res.status = 302
      @already_built_response = true
      session.store_session(@res)
    end

    def render_content(content, content_type)
      raise "Double Render" if already_built_response?
      @res.body = content
      @res.content_type = content_type
      @already_built_response = true
      session.store_session(@res)
    end

    # method exposing a `Session` object
    def session
      @session ||= Session.new(@req)
    end
  end
end
