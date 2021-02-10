describe Nautilus::Blockchain::Transaction do

  it "build valid reward" do
    genesis_signature = "ca321a0a60ab256711e09ff74342023a2f971ad1e79a2874511962eff6ccc022"
    genesis_rewards_account = "Nxe2a5cf93eb9d96d05f8e06bcc1b3c0ad5a9ca85c"
    rewards = "32000000000000000000"
    transaction = Nautilus::Blockchain::Transaction.build_reward(genesis_rewards_account, rewards, genesis_rewards_account)
    transaction.valid?.should eq true

  end

end
