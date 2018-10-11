[
  inputs: ["*.{ex,exs}", "{config,lib,priv,test,web,rel}/**/*.{ex,exs}"],
  locals_without_parens: [
    # Migrations
    drop: 1,
    create: 1,

    # Tests
    post: 2,
    post: 3,
    get: 2,

    # Channels
    send: 2,
    push: 3,
    broadcast!: 3,

    # Controllers
    render: 2,
    render: 3,

    # Schemas/GraphQL Types
    field: 1,
    field: 2,
    field: 3,

    # GraphQL
    arg: 2,
    resolve: 1,
    value: 1,
    description: 1,
    parse: 1,
    serialize: 1,
    import_types: 1,

    # Ecto.Query
    from: 1,
    from: 2,

    # Models
    has_many: 2,
    has_many: 3,
    has_one: 2,
    has_one: 3,
    belongs_to: 2,
    belongs_to: 3,

    # Views
    content_tag: 2,
    content_tag: 3,

    # Sockets
    channel: 2,
    transport: 2,
    transport: 3,

    # Endpoint
    plug: 1,
    plug: 2,
    socket: 2,
    json: 2,

    # rel/config.exs
    set: 1,

    # Router
    get: 3,
    put: 3,
    patch: 3,
    post: 3,
    delete: 3,
    resources: 2,
    resources: 3,
    pipe_through: 1,
    forward: 2
  ]
]
