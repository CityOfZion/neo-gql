# NeoGQL

## A GraphQL Blockchain Explorer for Neo.

### Setup

```sh
git clone https://github.com/ambethia/neo-gql.git
cd neo-gql
bundle install
rake db:setup
NEO_NET=test rake sync
rails server
```

### Private Blockchain

Edit `config/seed_list.yml` and set `NEO_NET` to `private` when syncing.
