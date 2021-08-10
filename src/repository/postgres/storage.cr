module Storage
    
    class User
        property username, password, email

        def initialize(username = "", password = "", email = "")
            @username = username
            @password = password
            @email = email
        end
    end

    class Storage
        POSTGRES_URI = "postgres://cynthia:philippa@localhost:5556/vergen"

        def prepare
            db = DB.open POSTGRES_URI
            begin 
                db.exec "DROP TABLE IF EXISTS users"
                db.exec "CREATE TABLE users(user_id SERIAL PRIMARY KEY, username VARCHAR(100), password VARCHAR(100), email VARCHAR(100))"
            ensure
                db.close
            end
        end

        def create(username : String, password : String, email : String)
            db = DB.open POSTGRES_URI
            begin
                db.exec "INSERT INTO users(username, password, email) VALUES($1, $2, $3)", username, password, email            
            ensure
                db.close
            end
        end

        def get(username : String)
            db = DB.open POSTGRES_URI
            user = User.new(username)

            begin
                db.query "SELECT password, email FROM users WHERE username=$1", username do |rs|
                    rs.each do
                        user.password = rs.read(String)
                        user.email = rs.read(String)
                    end
                end
            ensure
                db.close
            end

            return user
        end

        def get_all
            db = DB.open POSTGRES_URI
            users = [] of User

            begin 
                db.query "SELECT username, password, email FROM users" do |rs|
                    rs.each do
                        user = User.new(
                            rs.read(String),
                            rs.read(String),
                            rs.read(String),
                            )

                        users << user
                    end
                end
            ensure
                db.close
            end

            return users
        end
    end
end