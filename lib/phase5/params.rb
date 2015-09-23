require 'uri'
require 'byebug'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @req = req
      @params ||= route_params
      parse_www_encoded_form(@req.query_string)
      parse_www_encoded_form(@req.body)
    end

    def [](key)
      @params[key.to_s] || @params[key.to_sym]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      return nil if www_encoded_form.nil?
      query = URI::decode_www_form(www_encoded_form)
      query.map do |q|
        if q.first[/\[.*\]/]
          key_array = parse_key(q.first)
          #create first hash array
          current = @params
          key_array[0..-2].each do |key|
            current[key] ||= {}
            current = current[key]
          end
          current[key_array.last] = q.last
        else
          @params[q.first] = q.last
        end
      end
      query
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
