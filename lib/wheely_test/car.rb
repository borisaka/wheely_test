module WheelyTest
  class Car
    include Mongoid::Document

    field :location, type: Array
    field :available, type: Boolean
    field :num, type: String

    validates_presence_of :num, :location, :available
    validates_uniqueness_of :num

    index({location: "2d"})

    before_update :update_eta_cache

    # Veri primitive. I am geonoob
    def self.geo_key(lat, long)
      "#{lat.round(2)}_#{long.round(2)}"
    end

    def uncache
      keys = WheelyTest.cache.keys("*#{num}*")
      keys.each{|key| WheelyTest.cache.del(key) }
    end

    # Cashing eta by 3 cars: "#{rounded_lat}_#{rounded_long}:car1.car2.car3"
    # It would be cleared if one of cars moving to some distance
    def self.eta(lat, long)
      if eta_key = WheelyTest.cache.keys("eta_#{geo_key(lat,long)}:*").first
        {cached: true, eta:  WheelyTest.cache.get(eta_key)}
      else
        cars = where(available: true).geo_near([lat, long]).first(3)
        distances = cars.map{|car| car['geo_near_distance']}
        eta = (distances.sum / distances.size) * 1.5
        eta = eta.round
        WheelyTest.cache.set("eta_#{geo_key(lat,long)}:#{cars.map(&:num).join(".")}", eta)
        {cached: false, eta: eta}
      end

    end

    def as_json(options={})
      super(options).except!('_id')
    end

    protected
    # destroying ETA if car going to far
    def update_eta_cache
      if changes['location'] || changes['available']
        WheelyTest.logger.debug('Location changed')
        old_loc = changes['location'].first
        if Math.hypot(old_loc[0]-location[0],old_loc[1]-location[1]) > 0.01 || changes['available']
          WheelyTest.logger.debug('Clearing cache')
          uncache
        end
      end
    end

  end
end