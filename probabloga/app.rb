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

get '/' do
	#vivod spiska postov na ekran iz bd
	@results = @db.execute 'select * from Posts order by id desc' #select * from Posts order by id desc - kod izsqlite3 vivodit dannie iz bd naoborot

	erb :index
end

#obrabotchik get zaprosa /new(brauzer poluchaet stranicu s servera)
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

#sohranenie dannih v BD
@db.execute 'insert into posts (content, created_date) values (?, datetime())',[aaa] #kod iz sqlite,kotory vstavlyaet text posta & datu(data avtomatom)

#perenapravlenie na glavnuyou stranicu
redirect to '/'
end

get '/details/:post_id' do
	#delaem obrabotchik individualnogo url dlya kagdogo posta(poluchaem peremennuyou iz url)
	post_id = params[:post_id]
	#poluchaem spisok postov(u nas budet tolko odin post)(vibiraem iz BD vse posty s id, kotory ukazan v url)
	results = @db.execute 'select * from Posts where id = ?', [post_id] 
	#vibiraem etot odin post v peremennuyou @row
	@row = results[0]
	#vozvrashaem predstavlenie details.erb
	erb :details
end