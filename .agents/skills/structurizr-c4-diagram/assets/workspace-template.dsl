workspace "System Name" "C4 model for the system in scope." {
    !identifiers hierarchical

    model {
        user = person "Primary User" "Uses the system."

        system = softwareSystem "System Name" "Replace with the repository-backed description." {
            api = container "API" "Replace with the main application runtime boundary." "Go"
            db = container "Database" "Replace with the primary datastore." "PostgreSQL" "Database"
        }

        external = softwareSystem "External System" "Replace with a real dependency if one exists."

        user -> system "Uses"
        api -> db "Reads from and writes to" "SQL"
        api -> external "Calls" "HTTPS/JSON"
    }

    views {
        systemContext system "system-context" {
            include *
            autoLayout lr
        }

        container system "containers" {
            include *
            autoLayout lr
        }

        styles {
            element "Person" {
                shape Person
            }
            element "Software System" {
            }
            element "Container" {
            }
            element "Database" {
                shape Cylinder
            }
        }
    }

    configuration {
        scope softwaresystem
    }
}
