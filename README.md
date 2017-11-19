# NeoGQL

## A GraphQL Blockchain Explorer for Neo.

### Setup

```sh
git clone https://github.com/ambethia/neo-gql.git
cd neo-gql
./bin/setup
NEO_NET=test ./bin/rake sync
./bin/rails server
```

Use the environment variable `NEO_NET`, set to either `main` or `test`, to choose which blockchain to sync.

### Private Blockchain

Set the `NEO_NET` environment variable to a comma separate list of nodes, e.g.:

```
NEO_NET=http://localhost:10333,http://localhost:10334,http://localhost:10334,http://localhost:10336
```

---

<p align="center">
  <img src="https://i.imgur.com/a8SIj9e.png">
</p>
