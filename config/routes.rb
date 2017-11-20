Rails.application.routes.draw do
  post '/graphql', to: 'graphql#execute'

  # REST API (neon-wallet-db compatible)
  scope :v2, controller: :neon do
    get 'network/nodes', action: :network_nodes
    get 'network/best_node', action: :network_best_node
    get 'block/sys_fee/:block_index', action: :block_sys_fee
    get 'block/height', action: :block_height
    get 'address/balance/:address', action: :address_balance
    get 'address/claims/:address', action: :address_claims
    get 'address/history/:address', action: :address_history
    # get 'transaction/<txid', action: :transaction
    post 'log', action: :log
    get 'version', action: :version
  end
end
