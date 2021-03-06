module Clumpy
  module ClusterBehavior
    attr_accessor :latitude, :longitude, :points, :bounds

    def initialize(point, options = {})
      @latitude  = point.latitude
      @longitude = point.longitude
      @points    = [point]
      @options   = options

      @bounds    = Bounds.new(@latitude, @longitude, options[:width], options[:length])
    end

    def contains?(point)
      @bounds.latitude.include?(point.latitude) &&
      @bounds.longitude.include?(point.longitude)
    end

    def reposition
      @latitude  = @points.inject(0.0) { |m, p| m + p.latitude } / @points.size
      @longitude = @points.inject(0.0) { |m, p| m + p.longitude } / @points.size
    end

    def as_json(*)
      bounds =  {
        northeast: {
          latitude: @points.map(&:latitude).max,
          longitude: @points.map(&:longitude).max,
        },
        southwest: {
          latitude: @points.map(&:latitude).min,
          longitude: @points.map(&:longitude).min,
        }
      }

      {
        latitude:  latitude,
        longitude: longitude,
        size:      @points.size,
        bounds:    bounds,
        values:    value_list,
      }
    end

    def value_list
      case @options[:include_values]
      when true  then @points
      when false then []
      else
        values_threshold = @options[:values_threshold] || 10
        @points.size <= values_threshold ? @points : []
      end
    end
  end
end
