import Vapor
import HTTP
import Foundation

class UserController: ResourceRepresentable {
  func login(request: Request) throws -> ResponseRepresentable {
    guard let userName = request.data["username"]?.string,
      let password = request.data["password"]?.string else {
      throw Abort.badRequest
    }

    if let user = try User.query().filter("user_name", userName).all().first {
      let encryptedPassword = try drop.hash.make(password)
      if user.password == encryptedPassword {
        return Response(redirect: "/posts")
      } else {
        return "Login failed"
      }
    }

    throw Abort.badRequest
  }

  func indexView(request: Request) throws -> ResponseRepresentable {
    return try drop.view.make("login")
  }

  func makeResource() -> Resource<User> {
    return Resource(index: indexView)
  }
}
