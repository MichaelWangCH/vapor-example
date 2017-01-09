import Vapor
import Foundation
import Fluent

struct User: Model {
  var id: Node?
  var userName: String
  var email: String
  var password: String

  var exists: Bool = false

  init(userName: String, email: String, password: String) {
    self.userName = userName
    self.email = email
    self.password = password
  }

  init(node: Node, in context: Context) throws {
    id = try node.extract("id")
    userName = try node.extract("userName")
    email = try node.extract("email")
    password = try node.extract("password")
  }

  func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      "id": id,
      "userName": userName,
      "email": email,
      "password": password,
      ])
  }
}

extension User: Preparation {
  static func prepare(_ database: Database) throws {
  }

  static func revert(_ database: Database) throws {
  }
}
