require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db #inicializiruem globaln peremen
	@db = SQLite3::Database.new 'leprosorium.db' # v module sqlite suchestvuet class Database, v kotorom est metod .new,kotory prinimaet parametr leprosorium.db
	@db.results_as_hash = true #rezultaty vozvrashayoutsya v vide hash ,a ne v vide massiva(udobnee k nim obrashatsya)(stroka neobyazatelna)
end

#before vizivaetsya kagdy raz pri perezagruzke lyouboy stranicy
before do
	init_db
end

#sozdanie tablicy v BD
configure do #metod configuracii vizivaetsya kagdy raz pri inicializacii prilogeniya(pri izmenenii file(kod programmy) ili,& obnovlenii stranicy)
	init_db
	#vstavlyaem kod sozdanoy v programme sqlite3, obyazatelno vstavlyaem 'IF NOT EXISTS' dlya togo,chtoby tabl ne peresozdavalas zanovo
	@db.execute 'CREATE TABLE IF NOT EXISTS posts (  
    			id           INTEGER PRIMARY KEY AUTOINCREMENT,
    			created_date DATE,
   				 content      TEXT);
				'
end

#obrabotchik get zaprosa /new(brauzer poluchaet stranicu s servera)
get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/n003ew' do
  erb :new #podgrugaem file new.erb
end

post '/new' do #obrabotchik post zaprosa /new(brauzer otpravlyaet dannie na server)
  aaa = params[:aaa] #poluchaem peremennuyou iz post zaprosa

#proverka parametrov (vvel li chto to polzovatel v okno komenta)
if aaa.length <= 0
	@error = 'vvedite text v post'
	return erb :new
end

@db.execute 'insert into posts (content, created_date) values (?, datetime())',[aaa] #kod iz sqlite,kotory vstavlyaet text posta & datu(data avtomatom)

erb "vi vvely #{aaa}"
end