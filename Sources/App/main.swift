import Vapor
import VaporPostgreSQL

let drop = Droplet()
drop.preparations.append(Post.self)

do {
    try drop.addProvider(VaporPostgreSQL.Provider.self)
} catch {
    assertionFailure("Error adding provider: \(error)")
}

drop.post("post") { req in
    var post = try Post(node: req.json)
    try post.save()

    return try post.makeJSON()
}

drop.resource("posts", PostController())

drop.run()
