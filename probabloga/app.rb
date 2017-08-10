require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db #inicializiruem globaln peremen
	@db = SQLite3::Database.new 'leprosorium.db' # v module sqlite suchestvuet class Database, v kotorom est metod .new,kotory prinimaet parametr leprosorium.db
	@db.results_as_hash = true #rezultaty vozvrashayoutsya v vide hash ,a ne v vide massiva(udobnee k nim obrashatsya)(stroka neobyazatelna)
end

before do
	init_db
end

#sozdanie tablicy v BD
configure do #metod configuracii vizivaetsya kagdy raz pri inicializacii prilogeniya(pri izmenenii file ili,& obnovlenii stranicy)
	init_db
	#vstavlyaem kod sozdanoy v programme sqlite3, obyazatelno vstavlyaem 'IF NOT EXISTS' dlya togo,chtoby tabl ne peresozdavalas zanovo
	@db.execute 'CREATE TABLE IF NOT EXISTS posts (  
    			id           INTEGER PRIMARY KEY AUTOINCREMENT,
    			created_date DATE,
   				 content      TEXT);
				'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/n003ew' do
  erb :new #podgrugaem file new.erb
end

post '/new' do
  aaa = params[:aaa]

erb "vi vvely #{aaa}"
end