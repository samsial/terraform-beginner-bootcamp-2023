require 'sinatra'
require 'json'
require 'pry'
require 'active_model'

#we will emulate having a state or database for this development server
# by setting a global varialbe. You would never use a global variable
# in a production server.

$home = {}

#this is a ruby class that includes validations from activerecord.
#this will represent our home resource as a Ruby Object
class Home
  #active model is part of ruby on rails
  #it is used as an ORM. It has a module within ActiveModel that provides validations
  #The production Terratowns server is rails and uses very similar and in most cases identical validation
  #https://guides.rubyonrails.org/active_model_basics.html
  include ActiveModel::Validations
  #create some virtual attributes stored on this object
  #This will set a getter and setter
  #eg home - new Home()
  #home.town = 'hello' #setter
  #home.town() #getter
  attr_accessor :town, :name, :description, :domain_name, :content_version

  #name of the town
  validates :town, presence: true, inclusion: { in: [
    'cooker-cove',
    'melomaniac-mansion',
    'video-valley',
    'the-nomad-pad',
    'gamers-grotto'
  ]}
  #visible to all users
  #our home name
  validates :name, presence: true
  #visible to all users
  validates :description, presence: true
  #lock this down to only be from cloudfront
  validates :domain_name, 
    format: { with: /\.cloudfront\.net\z/, message: "domain must be from .cloudfront.net" }
    # uniqueness: true, 

  #content_version has to be an integer
  #we will make sure it is an incremental version in the control
    validates :content_version, numericality: { only_integer: true }
end

#we are extending a class from Sinatra base to turn this generic class to utilize the sinatra web framework
class TerraTownsMockServer < Sinatra::Base

  def error code, message
    halt code, {'Content-Type' => 'application/json'}, {err: message}.to_json
  end

  def error_json json
    halt code, {'Content-Type' => 'application/json'}, json
  end

  def ensure_correct_headings
    unless request.env["CONTENT_TYPE"] == "application/json"
      error 415, "expected Content_type header to be application/json"
    end

    unless request.env["HTTP_ACCEPT"] == "application/json"
      error 406, "expected Accept header to be application/json"
    end
  end

  #return a hard coded access token
  def x_access_code
    '9b49b3fb-b8e9-483c-b703-97ba88eef8e0'
  end

  #return a hard coded user_uuid
  def x_user_uuid
    'e328f4ab-b99f-421c-84c9-4ccea042c7d1'
  end

  def find_user_by_bearer_token
    #https://swagger.io/docs/specification/authentication/bearer-authentication/
    auth_header = request.env["HTTP_AUTHORIZATION"]
    #check if the bearer header is missing. if it is not there it will throw a 401 error
    if auth_header.nil? || !auth_header.start_with?("Bearer ")
      error 401, "a1000 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    #this splits the bearer header and compares the token to the one defined in the def x_access_code
    #if the token does not match, it will throw a 401 error
    code = auth_header.split("Bearer ")[1]
    if code != x_access_code
      error 401, "a1001 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    #was there a user_uuid in the body payload json, if it isnt provided it will throw a 401 error
    if params['user_uuid'].nil?
      error 401, "a1002 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    #the token and the uuid shoudl be matching for this user.
    unless code == x_access_code && params['user_uuid'] == x_user_uuid
      error 401, "a1003 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end
  end

  # CREATE
  post '/api/u/:user_uuid/homes' do
    ensure_correct_headings
    find_user_by_bearer_token
    #puts prints to the terminal
    puts "# create - POST /api/homes"

    #begin rescue is try catch. If an error occurs rescue it
    begin
      #Sinatra does not automatically parse json bodies as params like rails. So we manually parse them here
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # assign the payload to variables so we can work with them
    name = payload["name"]
    description = payload["description"]
    domain_name = payload["domain_name"]
    content_version = payload["content_version"]
    town = payload["town"]

    #print the variables to console to easier to debug/see what varaibles we have input into this endpoint
    puts "name #{name}"
    puts "description #{description}"
    puts "domain_name #{domain_name}"
    puts "content_version #{content_version}"
    puts "town #{town}"

    #create a new home model and set the attributes
    home = Home.new
    home.town = town
    home.name = name
    home.description = description
    home.domain_name = domain_name
    home.content_version = content_version
    
    #ensure our validation checks pass, otherwise return the errors
    unless home.valid?
      #return the error messages back as json
      error 422, home.errors.messages.to_json
    end

    #generate a uuid at random
    uuid = SecureRandom.uuid
    #print the random uuid
    puts "uuid #{uuid}"
    #will mock save our data to our mock database as global variable
    $home = {
      uuid: uuid,
      name: name,
      town: town,
      description: description,
      domain_name: domain_name,
      content_version: content_version
    }

    #will jsut return the user_uuid
    return { uuid: uuid }.to_json
  end

  # READ
  get '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# read - GET /api/homes/:uuid"

    # checks for house limit

    content_type :json
    #does the uuid for the home match the one in our mock databse
    if params[:uuid] == $home[:uuid]
      return $home.to_json
    else
      error 404, "failed to find home with provided uuid and bearer token"
    end
  end

  # UPDATE
  #very similar to create action
  put '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# update - PUT /api/homes/:uuid"
    begin
      # Parse JSON payload from the request body
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # Validate payload data
    name = payload["name"]
    description = payload["description"]
    domain_name = payload["domain_name"]
    content_version = payload["content_version"]

    unless params[:uuid] == $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end

    home = Home.new
    home.town = $home[:town]
    home.name = name
    home.description = description
    home.domain_name = domain_name
    home.content_version = content_version

    unless home.valid?
      error 422, home.errors.messages.to_json
    end

    return { uuid: params[:uuid] }.to_json
  end

  # DELETE
  delete '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# delete - DELETE /api/homes/:uuid"
    content_type :json

    if params[:uuid] != $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end

    #delete from our mock database
    $home = {}
    { message: "House deleted successfully" }.to_json
  end
end

#this is what will run the server
TerraTownsMockServer.run!