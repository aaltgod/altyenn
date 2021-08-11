get "/user/:user" do |env|
    username = env.params.url["user"]
    db = Storage::Storage.new
    user = db.get(username)
    password, email = user.password, user.email
    
    if user.password == ""
        error = "User is not found"
        next render "src/views/error.ecr", "src/views/layouts/layout.ecr"
    end    

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
    puts env.params.body
    
    name = env.params.body["name"]? 
    if name.nil?
        env.response.status_code = 400
        error = "400"        
        next render "src/views/error.ecr", "src/views/layouts/layout.ecr"
    end

    db = Storage::Storage.new
    user = db.get(name)
    if user.username != "" 
        env.response.status_code = 400
        error = "User with this nickname already exists"
        next render "src/views/error.ecr", "src/views/layouts/layout.ecr" 
    end

    password = env.params.body["pswd"]?
    if password.nil?
        error = "400"
        next render "src/views/error.ecr", "src/views/layouts/layout.ecr"
    end

    email = env.params.body["email"]? 
    if email.nil?
        env.response.status_code = 400
        error = "400"
        next render "src/views/error.ecr", "src/views/layouts/layout.ecr"
    end

    puts "HEADERS", name, password, email

    db.create(name, password, email)

    render "src/views/home.ecr", "src/views/layouts/layout.ecr"
end

error 404 do
    error = "404"
    render "src/views/error.ecr", "src/views/layouts/layout.ecr"
end