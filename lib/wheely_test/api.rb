require 'sinatra'
require 'wheely_test'
require 'json'

before do
  content_type :json
end

get '/' do
  content_type :text
  status 404
  body "not here"
end

get '/cars' do
  {data: WheelyTest::Car.all.to_a}.to_json
end

get '/cars/:num' do
  car = WheelyTest::Car.where(num: params['num']).first
  if car
    car.to_json
  else
    status 404
    body ({error: 'car not found'}.to_json)
  end
end

# TODO to mach code.
patch '/cars/:num' do
  body = JSON.parse(request.body.read)
  car = WheelyTest::Car.where(num: params['num']).first
  if car
    if body.key?('location')
      begin
        car.location = body['location']
      rescue Mongoid::Errors::InvalidValue => e
        status 400
        body({error: 'invalid location format'})
      end
    end
    if body.key?('available')
      car.available = body['available']
    end
    if car.changed?
      if car.save
        status 204
      else
        status 400
        body ({error:car.errors}.to_json)
      end
    else
      status 204
    end
  else
    status 404
    {error: 'car not found'}.to_json
  end
end

post '/cars' do
  attrs = JSON.parse request.body.read
  begin
    puts attrs
    car =  WheelyTest::Car.new(attrs)
    if car.save
      status 201
    else
      status 400
      {error: car.errors}.to_json
    end
  rescue Mongoid::Errors::InvalidValue => e
    status 400
    {error: "location must be like [23.35313, 11.234234234]"}.to_json
  end
end

get '/eta' do
  long = params['long']
  lat = params['lat']
  WheelyTest::Car.eta(long.to_f, lat.to_f).to_json
end


