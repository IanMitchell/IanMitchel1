require 'sinatra'
require 'slim'
require 'sass'


set :public_folder, File.dirname(__FILE__) + '/public'
set :views, File.dirname(__FILE__) + '/views/'


get '/' do
  slim :index, :locals => { :title => 'Web Developer' }
end

get '/resume' do
  slim :resume, :layout => false
end

get '/projects/?' do
  list = Dir.glob(File.dirname(__FILE__) + '/projects/*.md')

  list.each do |file|
    file.gsub! File.dirname(__FILE__) + '/projects/', ''
    file.gsub! '.md', ' '
  end

  slim :list, :locals => { :projects => list, :title => 'Projects' }
end

get '/project/:name' do
  begin
    project = File.open(File.dirname(__FILE__) + '/projects/' + params[:name] + '.md').read
    slim :project, :locals => { :title => params[:name].gsub!('-', ' '), :content => markdown(project) }
  rescue
    slim :error404, :locals => { :title => '404 Not Found' }
  end
end

get '/stylesheets/*' do
  content_type 'text/css'
  sass '../stylesheets/'.concat(params[:splat].join.chomp('.css')).to_sym
end

not_found do
  slim :error404, :locals => { :title => '404 Not Found' }
end
