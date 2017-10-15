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

### Private Blockchain

Edit `config/seed_list.yml` and set `NEO_NET` to `private` when syncing.

---

<p align="center">
  <img src="https://i.imgur.com/a8SIj9e.png">
</p>
