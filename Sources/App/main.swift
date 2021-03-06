import Vapor
import VaporPostgreSQL

let drop = Droplet()

// Vapor runs migrations/preparations for models
drop.preparations.append(Post.self)
drop.preparations.append(Blog.self)
drop.preparations.append(User.self)

do {
  // add VaporPostgreSQL provider, this will bind the data to the database and the models automatically down the line.
  try drop.addProvider(VaporPostgreSQL.Provider.self)
} catch {
  assertionFailure("Error adding provider: \(error)")
}

// Creating a route group
drop.group("api") { api in
  api.resource("blogs", BlogController())
}

drop.get("/", handler: PostController().indexView)
drop.resource("posts", PostController())
drop.get("addpost", handler: PostController().addPost)
drop.resource("users", UserController())
drop.post("/users", handler: UserController().login)

drop.run()
