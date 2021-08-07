get "/:user" do |env|
    user = env.params.url["user"]
    render "src/views/user.ecr", "src/views/layouts/layout.ecr"
end

get "/" do
    render "src/views/home.ecr", "src/views/layouts/layout.ecr"
end

error 404 do
    "404"
end