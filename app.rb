require 'sinatra/base'
require 'mongo'
require 'haml'
require 'mongo_mapper'

MongoMapper.database = 'blank'

class Item
   include MongoMapper::Document

   key :caption, String
   key :image, String

end

class Blank < Sinatra::Base

   set :sessions,true
   set :haml, :format => :html5


   get '/admin' do
      protected!
      @title = "admin"
	
      haml :admin	 

   end

   post '/admin' do

      item = Item.create({:itemtype=>params[:itemtype],:desc=>params[:desc],:size=>params[:size],:price=>params[:price],:image=>params[:file][:filename]})
      item.save


      unless params[:file] &&
	 (tmpfile = params[:file][:tempfile]) &&
	 (name = params[:file][:filename])
	 @error = "No file selected"
	 return haml(:admin)
      end
      directory = "public/css/img"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(tmpfile.read) }
      redirect '/admin'
   end

   post '/edit/:id' do
      item = Item.find(params[:id])
         item.update_attributes(
 	:caption => params[:caption],
	:image => params[:file][:filename]
	 )
     unless params[:file] &&
	 (tmpfile = params[:file][:tempfile]) &&
	 (name = params[:file][:filename])
	 @error = "No file selected"
	 return haml(:admin)
      end
      directory = "public/css/img"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(tmpfile.read)}

      redirect '/admin'

   end

   get '/edit/:id' do
     @title = "edit item"
   
   @update_item = Item.where($oid=>:id)

    haml :edit

   end

   get '/delete/:id' do
   
    item = Item.where(:id=>params[:id])
    item.remove

    redirect '/admin'

   end

   get '/' do
      @title = "Home"
      haml :index

   end

   get '/galleries' do
      @title = "Photo Galleries"
      haml :galleries
   end

   get '/microblog' do
      @title = "Microblog"
      haml :microblog
   end

   get '/contact' do
      @title = "Contact"
      'contact form'
      haml :contact
   end



end

require_relative 'helpers/init'


