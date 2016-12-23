import Vapor
import HTTP
import Foundation

final class PostController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        // get all the post objects from the database
        return try Post.all().makeNode().converted(to: JSON.self)
    }

    func create(request: Request) throws -> ResponseRepresentable {
        var post = try request.post()
        post.id = UUID().uuidString.makeNode()

        try post.save()

        return post
    }

    func show(request: Request, post: Post) throws -> ResponseRepresentable {
        return post
    }

    func delete(request: Request, post: Post) throws -> ResponseRepresentable {
        try post.delete()

        return JSON([:])
    }

    func update(request: Request, post: Post) throws -> ResponseRepresentable {
        let new = try request.post()
        var post = post
        post.content = new.content
        try post.save()

        return post
    }

    func makeResource() -> Resource<Post> {
        return Resource(
            index: index,
            store: create,
            show: show,
            modify: update,
            destroy: delete
        )
    }
}

extension Request {
    func post() throws -> Post {
        guard let json = json,
              let _ = json["title"]?.string,
              let _ = json["content"]?.string,
              let _ = json["author"]?.string else { throw Abort.badRequest }

        return try Post(node: json)
    }
}
