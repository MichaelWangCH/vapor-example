import Vapor
import Foundation
import Fluent

struct Blog: Model {
    var id: Node?
    var title: String
    var description: String

    var exists: Bool = false

    init(title: String, description: String) {
        self.id = UUID().uuidString.makeNode()
        self.title = title
        self.description = description
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        title = try node.extract("title")
        description = try node.extract("description")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "title": title,
            "description": description
        ])
    }
}

extension Blog: Preparation {
    static func prepare(_ database: Database) throws {
    }

    static func revert(_ database: Database) throws {
    }
}
