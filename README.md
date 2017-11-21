<p align="center">
  <img 
    src="http://res.cloudinary.com/vidsy/image/upload/v1503160820/CoZ_Icon_DARKBLUE_200x178px_oq0gxm.png" 
    width="125px"
  >
</p>

<h1 align="center">neo-gql</h1>

<p align="center">
  A GraphQL Blockchain Explorer for <b>NEO</b>.
</p>

<p align="center">
  <a href="https://github.com/CityOfZion/neo-gql/releases">
    <img src="https://img.shields.io/github/tag/CityOfZion/neo-gql.svg?style=flat">
  </a>
</p>

<p align="center">
  <img src="https://i.imgur.com/a8SIj9e.png">
</p>

## What?

- A GraphQL API for exploring the NEO blockchain.
- Retrieve blocks, transactions, account balances, etc.
- Also includes a partial implementation of the [`neon-wallet-db` API](https://github.com/CityOfZion/neon-wallet-db)

```sh
git clone https://github.com/CityOfZion/neo-gql.git
cd neo-gql
./bin/setup
./bin/rails server
```

Use the environment variable `NEO_NET`, set to either `main` or `test`, to choose which blockchain to sync. The default, if unset, is `test`.

### Private Blockchain

Set the `NEO_NET` environment variable to a comma separate list of nodes, e.g.:

```
NEO_NET=http://localhost:10333,http://localhost:10334,http://localhost:10334,http://localhost:10336
```

## Help

- Open a new [issue](https://github.com/CityOfZion/neo-gql/issues/new) if you encountered a problem.
- Or ping **@ambethia** on the [NEO Slack](https://neo-slack-invite.herokuapp.com).
- Submitting PRs to the project is always welcome! 🎉

## License

- Open-source [MIT](https://github.com/CityOfZion/neo-gql/blob/master/LICENSE).
- Main author is [@ambethia](https://github.com/ambethia).
- This project adheres to the [Contributor Covenant Code of Conduct](https://github.com/goreleaser/goreleaser/blob/master/CODE_OF_CONDUCT.md).
