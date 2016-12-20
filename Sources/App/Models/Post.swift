import Vapor
import Fluent
import Foundation

struct Post: Model {
    var id: Node?
    var title: String
    var content: String
    var author: String

    // used by fluent internally
    var exists: Bool = false
    
    init(title: String, content: String, author: String) {
        self.id = UUID().uuidString.makeNode()
        self.title = title
        self.content = content
        self.author = author
    }

    // NodeInitializable
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        title = try node.extract("title")
        content = try node.extract("content")
        author = try node.extract("author")
    }

    // NodeRepresentable
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "title": title,
            "author": author,
            "content": content
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
