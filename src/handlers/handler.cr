get "/user/:user" do |env|
    user = env.params.url["user"]
    render "src/views/user.ecr", "src/views/layouts/layout.ecr"
end

get "/" do
    render "src/views/home.ecr", "src/views/layouts/layout.ecr"
end

get "/create_user" do
    render "src/views/create_user.ecr", "src/views/layouts/layout.ecr" 
end

post "/create_user" do |env|
    name = env.params.body["name"]? 
    if name.nil?
        next "400"
    end

    email = env.params.body["email"]? 
    if email.nil?
        next "400"
    end

    pwd = env.params.body["pswd"]?
    if pwd.nil?
        next "400"
    end

    "200"
end

error 404 do
    "404"
end