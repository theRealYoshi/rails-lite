require 'byebug'

module Phase6
  class Route
    attr_reader :pattern, :http_method, :controller_class, :action_name

    def initialize(pattern, http_method, controller_class, action_name)
      @pattern, @http_method = pattern, http_method
      @controller_class, @action_name = controller_class, action_name
    end

    # checks if pattern matches path and method matches request method
    def matches?(req)
      req.path[@pattern] && @http_method == req.request_method.downcase.to_sym
    end

    # use pattern to pull out route params (save for later?)
    # instantiate controller and call controller action
    def run(req, res)
      route_params = Hash.new
      match_data = @pattern.match(req.path)
      match_data.names.each do |name|
        route_params[name] = match_data[name]
      end
      c = @controller_class.new(req, res, route_params)
      c.invoke_action(@action_name)
    end
  end

  class Router
    attr_reader :routes

    def initialize
      @routes = []
    end

    # simply adds a new route to the list of routes
    def add_route(pattern, method, controller_class, action_name)
      @routes << Route.new(pattern,
                            method,
                            controller_class,
                            action_name)
    end

    # evaluate the proc in the context of the instance
    # for syntactic sugar :)
    def draw(&proc)
      #gets the pattern, method, controller class and action name and calls the method
      self.instance_eval(&proc)
    end

    # make each of these methods that
    # when called add route
    [:get, :post, :put, :delete].each do |http_method|
        define_method(http_method) do |pattern, controller_class, action_name|
          add_route(pattern, http_method, controller_class, action_name)
        end
    end

    # should return the route that matches this request
    def match(req)
      routes = @routes.select { |route| route.pattern.match(req.path) }
      return nil if routes.empty?
      routes
    end

    # either throw 404 or call run on a matched route
    def run(req, res)
      matched_route = match(req)
      return res.status = 404 if matched_route.nil?
      matched_route.first.run(req, res)
    end
  end
end
