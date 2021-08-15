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

get "/users" do |env|
    field, order = "", ""
    query = env.params.query
    unless query.size == 0
        field = query["field"]?
        if field.nil? || !Tool.field_exists?(field)
            Log.info {"Req [/users] Param [field] doesn't exist or not available"}
            env.response.status_code = 400
            error = "400"
            next render "src/views/error.ecr", "src/views/layouts/layout.ecr"
        end

        order = query["order"]?
        if order.nil? || !Tool.order_exists?(order)
            Log.info {"Req [/users] Param [order] doesn't exist or not available"}
            env.response.status_code = 400
            error = "400"
            next render "src/views/error.ecr", "src/views/layouts/layout.ecr"
        end
    end

    db = Storage::Storage.new
    users = db.get_all(field.size > 0 ? field : "username", order.size > 0 ? order : "ASC")
    
    render "src/views/users.ecr", "src/views/layouts/layout.ecr"
end

get "/create_user" do
    render "src/views/create_user.ecr", "src/views/layouts/layout.ecr" 
end

post "/create_user" do |env|
    name = env.params.body["name"]?
    if name.nil?
        Log.info {"Req [/create_user] Param [name] doesn't exist"}
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
        Log.info {"Req [/create_user] Param [pswd] doesn't exist"}
        error = "400"
        next render "src/views/error.ecr", "src/views/layouts/layout.ecr"
    end

    email = env.params.body["email"]? 
    if email.nil?
        Log.info {"Req [/create_user] Param [email] doesn't exist"}
        env.response.status_code = 400
        error = "400"
        next render "src/views/error.ecr", "src/views/layouts/layout.ecr"
    end

    balance = env.params.body["balance"]?
    if balance.nil? || balance.to_i?.nil?
        Log.info {"Req [/create_user] Param [balance] doesn't exist"}
        env.response.status_code = 400
        error = "400"
        next render "src/views/error.ecr", "src/views/layouts/layout.ecr"
    end
    balance = balance.to_i

    role = env.params.body["role"]? 
    if role.nil?
        Log.info {"Req [/create_user] Param [role] doesn't exist"}
        env.response.status_code = 400
        error = "400"
        next render "src/views/error.ecr", "src/views/layouts/layout.ecr"
    end

    db.create(name, password, email, balance, role)

    env.response.status_code = 200
    env.redirect "/"
end

error 404 do
    error = "404"
    render "src/views/error.ecr", "src/views/layouts/layout.ecr"
end