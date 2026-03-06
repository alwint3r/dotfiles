# Structurizr DSL Quick Reference

Use this file only when you need exact Structurizr DSL syntax or official source links while building a C4 workspace from a repository.

## Official Sources

- DSL overview: `https://docs.structurizr.com/dsl`
- Language reference: `https://docs.structurizr.com/dsl/language`
- Workspace scope: `https://docs.structurizr.com/workspaces/scope`
- CLI validate: `https://docs.structurizr.com/cli/validate`
- CLI inspect: `https://docs.structurizr.com/cli/inspect`

Relevant cookbook entry points from the DSL docs:

- system context diagrams
- container diagrams
- component diagrams
- deployment diagrams
- element styles

## Minimal Workspace Shape

```dsl
workspace "Name" "Description" {
    !identifiers hierarchical

    model {
        user = person "User" "Uses the system."

        system = softwareSystem "System" "Does a thing." {
            api = container "API" "Exposes the application interface." "Go"
            db = container "Database" "Stores application state." "PostgreSQL" "Database"
        }

        ext = softwareSystem "External System" "Provides a dependency."

        user -> system "Uses"
        api -> db "Reads from and writes to" "SQL"
        api -> ext "Calls" "HTTPS/JSON"
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
                background #1168bd
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
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
```

## Syntax Notes

- Use `workspace { model { ... } views { ... } configuration { ... } }` as the standard top-level layout.
- Use `person`, `softwareSystem`, `container`, and `component` to define C4 elements.
- Use `source -> destination "Description" "Technology"` to define relationships.
- Use explicit identifiers and reuse them in relationships and views.
- Use `systemContext <softwareSystemIdentifier> <key>`, `container <softwareSystemIdentifier> <key>`, and `component <containerIdentifier> <key>` to define views.
- Use `include *` for the default full view, or list explicit identifiers when you need tighter control.
- Use `autoLayout lr`, `autoLayout rl`, `autoLayout tb`, or `autoLayout bt` for automatic layout.
- Use `element "<tag>"` blocks inside `styles` to style default or custom tags.
- Use `configuration { scope softwaresystem }` when the workspace centers on one software system and you want stricter validation around view scope.

## Accuracy Rules For Codebase Modeling

- Do not map source directories directly to containers.
- Do not model components unless the codebase exposes real internal boundaries inside one container.
- Prefer a short assumptions note outside the DSL over embedding guesses as facts in the model.
- Keep the default output at system context plus container views unless the user asked for more.
