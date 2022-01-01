require "pg"
require "pry"
class DatabasePersistence
  
  def initialize(logger)
    @db = if Sinatra::Base.production?
            PG.connect(ENV['DATABASE_URL'])
          else
            PG.connect(dbname: "seating")
          end
    @logger = logger
  end
  
  def query(statement, *params)
    @logger.info("#{statement} : #{params}")
    @db.exec_params(statement, params)
  end
  
  def all_classes
    sql = "SELECT * FROM classes;"
    results = query(sql)
    results.map do |tuple|
      {id: tuple["id"], class_name: tuple["class"], num_students: tuple["num_students"]}
    end
  end
  
  def add_class(class_name, num_students)
    sql = "INSERT INTO classes (class, num_students)VALUES ($1, $2)"
    query(sql, class_name, num_students)
  end
  
  def check_unique_class(class_name)
    sql = "SELECT * FROM classes WHERE class = $1"
    result = query(sql, class_name)
    result.ntuples > 0
  end

  def disconnect
    @db.close
  end
end