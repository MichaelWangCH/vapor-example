import Vapor
import Fluent
import Foundation

extension Date {
  static func fromTimestamp(_ timestamp: Int) -> Date {
    return Date(timeIntervalSince1970: TimeInterval(timestamp))
  }

  static func optionalFromTimestamp(_ timestamp: Int?) -> Date? {
    guard let stamp = timestamp else { return nil }
    return fromTimestamp(stamp)
  }
}

struct Post: Model {
  var id: Node?
  var uuid: String
  var title: String
  var markdown: String
  var html: String
  var status: String
  var language: String

  var createdAt: Date
  var createdBy: Int
  var updatedAt: Date
  var updatedBy: Int
  var publishedAt: Date?
  var publishedBy: Int?
  var author: String
  var url: String

  // used by fluent internally
  var exists: Bool = false

  init(title: String, markdown: String, html: String, status: String, language: String,
       createdAt: Date, createdBy: Int, updatedAt: Date, updatedBy: Int,
       publishedAt: Date?, publishedBy: Int?, author: String, url: String) {
    self.id = nil
    self.uuid = UUID().uuidString
    self.title = title
    self.markdown = markdown
    self.html = html
    self.status = status
    self.language = language

    self.createdAt = createdAt
    self.createdBy = createdBy
    self.updatedAt = updatedAt
    self.updatedBy = updatedBy
    self.publishedAt = publishedAt
    self.publishedBy = publishedBy
    self.author = author
    self.url = url
  }

  // NodeInitializable
  init(node: Node, in context: Context) throws {
    id = try node.extract("id")
    uuid = try node.extract("uuid")
    title = try node.extract("title")
    markdown = try node.extract("markdown")
    html = try node.extract("html")
    status = try node.extract("status")
    language = try node.extract("language")

    createdAt = try node.extract("createdAt", transform: Date.fromTimestamp)
    createdBy = try node.extract("createdBy")
    updatedAt = try node.extract("updatedAt", transform: Date.fromTimestamp)
    updatedBy = try node.extract("updatedBy")
    publishedAt = try node.extract("publishedAt", transform: Date.optionalFromTimestamp)
    publishedBy = try node.extract("publishedBy")
    author = try node.extract("author")
    url = try node.extract("url")
  }

  // NodeRepresentable
  func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      "id": id,
      "uuid": uuid,
      "title": title,
      "markdown": markdown,
      "html": html,
      "status": status,
      "language": language,
      "createdAt": createdAt.timeIntervalSince1970,
      "createdBy": createdBy,
      "updatedAt": updatedAt.timeIntervalSince1970,
      "updatedBy": updatedBy,
      "publishedAt": publishedAt?.timeIntervalSince1970,
      "publishedBy": publishedBy,
      "author": author,
      "url": url
      ])
  }
}

extension Post: Preparation {
  static func prepare(_ database: Database) throws {
    //
  }

  static func revert(_ database: Database) throws {
    //
  }
}
