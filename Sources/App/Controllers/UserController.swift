import Vapor
import HTTP
import Foundation

class UserController: ResourceRepresentable {
  func index(request: Request) throws -> ResponseRepresentable {
    return try User.all().makeNode().converted(to: JSON.self)
  }

  func indexView(request: Request) throws -> ResponseRepresentable {
    return try drop.view.make("login")
  }

  func makeResource() -> Resource<User> {
    return Resource(index: indexView)
  }
}
