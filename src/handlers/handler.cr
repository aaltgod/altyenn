get "/user/:user" do |env|
    username = env.params.url["user"]

    db = Storage::Storage.new
    user = db.get(username)

    password = user.password
    email = user.email

    render "src/views/user.ecr", "src/views/layouts/layout.ecr"
end

get "/" do
    render "src/views/home.ecr", "src/views/layouts/layout.ecr"
end

get "/users" do
    db = Storage::Storage.new
    users = db.get_all
    
    render "src/views/users.ecr", "src/views/layouts/layout.ecr"
end

get "/create_user" do
    render "src/views/create_user.ecr", "src/views/layouts/layout.ecr" 
end

post "/create_user" do |env|
    name = env.params.body["name"]? 
    if name.nil?
        next "400"
    end

    password = env.params.body["pswd"]?
    if password.nil?
        next "400"
    end

    email = env.params.body["email"]? 
    if email.nil?
        next "400"
    end

    db = Storage::Storage.new
    db.create(name, password, email)

    "#{name}, #{password}, #{email}"
end

error 404 do
    "404"
end