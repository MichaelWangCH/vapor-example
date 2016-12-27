import Vapor
import HTTP
import Foundation

final class PostController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        // get all the post objects from the database
        return try Post.all().makeNode().converted(to: JSON.self)
    }

    func indexView(request: Request) throws -> ResponseRepresentable {
        let posts = try Post.all().makeNode()
        let parameters = try Node(node: [
                "posts": posts
            ])

        return try drop.view.make("index", parameters)
    }

  func addPost(request: Request) throws -> ResponseRepresentable {
    guard let title = request.data["title"]?.string,
          let author = request.data["author"]?.string,
          let content = request.data["content"]?.string else {
      throw Abort.badRequest
    }

    var post = Post(title: title, content: content, author: author)
    try post.save()

    return Response(redirect: "/posts")
  }

  func deletePost(request: Request, post: Post) throws -> ResponseRepresentable {
    try post.delete()

    return Response(redirect: "/posts")
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
