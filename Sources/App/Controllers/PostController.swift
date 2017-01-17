import Vapor
import HTTP
import Foundation

final class PostController: ResourceRepresentable {
  func index(request: Request) throws -> ResponseRepresentable {
    // get all the post objects from the database
    return try Post.all().makeNode().converted(to: JSON.self)
  }

  func indexView(request: Request) throws -> ResponseRepresentable {
    let session = try request.session()
    guard let _ = session.data["user"]?.string else {
      return Response(redirect: "/")
    }

    let posts = try Post.all().makeNode()
    let parameters = try Node(node: [
      "posts": posts
      ])

    return try drop.view.make("index", parameters)
  }

  func addPost(request: Request) throws -> ResponseRepresentable {
    return try drop.view.make("addpost")
  }

  func deletePost(request: Request, post: Post) throws -> ResponseRepresentable {
    try post.delete()

    return Response(redirect: "/posts")
  }

  func create(request: Request) throws -> ResponseRepresentable {
    guard let title = request.data["title"]?.string,
      let markdown = request.data["markdown"]?.string,
      let html = request.data["html"]?.string else {
        throw Abort.badRequest
    }

    var post = Post(title: title, markdown: markdown, html: html, status: "draft", language: "en-US", createdAt: Date(), createdBy: 1, updatedAt: Date(), updatedBy: 1, publishedAt: Date(), publishedBy: 1, author: 1, url: "test-url")
    try post.save()

    return Response(redirect: "/posts")
  }

  func show(request: Request, post: Post) throws -> ResponseRepresentable {
    let parameters = try Node(node: [
      "post": post
      ])

    return try drop.view.make("post", parameters)
  }

  func delete(request: Request, post: Post) throws -> ResponseRepresentable {
    try post.delete()

    return JSON([:])
  }

  func update(request: Request, post: Post) throws -> ResponseRepresentable {
    let new = try request.post()
    var post = post
    post.title = new.title
    try post.save()

    return post
  }

  func makeResource() -> Resource<Post> {
    return Resource(
      index: indexView,
      store: create,
      show: show,
      modify: update,
      destroy: delete
    )
  }
}

extension Request {
  func post() throws -> Post {
    guard let json = json else {
      throw Abort.badRequest
    }

    return try Post(node: json)
  }
}
