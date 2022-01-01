require "sinatra"
require "sinatra/content_for"
require "tilt/erubis"
require "pry"


require_relative "database_persistence"

configure do
  enable :sessions
  set :session_secret, "secret"
  set :erb, :escape_html => true

end

configure(:development) do
  require "sinatra/reloader"
  also_reload "database_persistence.rb"
end

helpers do
  
end

before do
  @storage = DatabasePersistence.new(logger)
end

get "/classes" do
  @classes = @storage.all_classes
  erb :classes, layout: :layout
end

get "/new_class" do
  erb :new_class, layout: :layout
end

def error_for_new_class(class_name, num_of_student)
  if num_of_student < 1 || class_name == ""
    "The class must have at least 1 student and a class name."
  elsif @storage.check_unique_class(class_name)
    "The class name must be unique."
  end
end

post "/classes" do
  class_name = params[:class_name].strip
  num_of_students = params[:num_students].to_i
  
  error = error_for_new_class(class_name, num_of_students)
  
  if error
    session[:error] = error
    erb :new_class, layout: :layout
  else
    @storage.add_class(class_name, num_of_students)
    session[:success] = "Class #{class_name} was created!"
    redirect "/classes"
  end
end





after do 
  @storage.disconnect
end