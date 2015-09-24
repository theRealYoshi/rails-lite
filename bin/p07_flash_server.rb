require 'webrick'
require_relative '../lib/phase4/controller_base'
require_relative '../lib/phase7/flash'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html

class MyFlash < Phase4::ControllerBase

  def flash
    @flash ||= Flash.new(@req)
  end

  def flash_now
    # debugger
    # if flash["count"] = 0
      render json: "jgadkljalgjklajgkldasfj;dasklgjadsl;kgjkadsl;jgdaskgl;adjflk"
    # end
  end
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  MyFlash.new(req, res).flash_now
end

trap('INT') { server.shutdown }
server.start
