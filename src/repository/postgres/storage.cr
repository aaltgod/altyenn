module Storage
    
    class User
        property username, password, email, balance, role

        def initialize(username = "", password = "", email = "", balance = 0, role = "")
            @username = username
            @password = password
            @email = email
            @balance = balance
            @role = role
        end
    end

    class Storage
        POSTGRES_URI = "postgres://cynthia:philippa@localhost:5556/vergen"

        def prepare
            db = DB.open POSTGRES_URI
            begin 
                # db.exec "DROP TABLE IF EXISTS users"
                # db.exec "CREATE TABLE users(user_id SERIAL PRIMARY KEY, username VARCHAR(100), password VARCHAR(100), email VARCHAR(100), balance INTEGER, role VARCHAR(20))"
            rescue ex : Exception
                Log.info {"Prepare exception : #{ex}"}
            ensure
                db.close
            end
        end

        def create(username : String, password : String, email : String, balance : Int32, role : String)
            db = DB.open POSTGRES_URI
            begin
                db.exec "INSERT INTO users(username, password, email, balance, role) VALUES($1, $2, $3, $4, $5)",
                 username, password, email, balance, role             
            rescue ex : Exception
                Log.info {"Create exception : #{ex}"}
            ensure
                db.close
            end
        end

        def get(username : String)
            db = DB.open POSTGRES_URI
            user = User.new

            begin
                db.query "SELECT password, email, balance, role FROM users WHERE username=$1", username do |rs|
                    rs.each do
                        user.password = rs.read(String)
                        user.email = rs.read(String)
                        user.balance = rs.read(Int32)
                        user.role = rs.read(String)
                    end
                end
            rescue ex : Exception
                Log.info {"Create exception : #{ex}"}
            ensure
                db.close
            end

            return user
        end

        def get_all(field : String, order : String)
            db = DB.open POSTGRES_URI
            users = [] of User

            begin 
                db.query "SELECT username, password, email, balance, role FROM users ORDER BY #{field} #{order}" do |rs|
                    rs.each do
                        user = User.new(
                            rs.read(String),
                            rs.read(String),
                            rs.read(String),
                            rs.read(Int32),
                            rs.read(String),
                            )

                        users << user
                    end
                end
            rescue ex : Exception
                Log.info {"Create exception : #{ex}"}
            ensure
                db.close
            end

            return users
        end
    end
end