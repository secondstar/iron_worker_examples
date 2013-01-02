puts "Starting PGConnect at #{Time.now}"

require 'pg'

conn = PG.connect(dbname: 'dbname',
                  host: 'host',
                  port: 5432,
                  user: 'blah',
                  password: 'murmur',
                  sslmode: 'require'
)

begin

  conn.exec("SELECT 1")
  puts 'Connected!'

rescue PG::Error => err
  puts "#{err.class} while testing connection: #{err.message}"
  conn.reset
end


puts 'Done'
