const { deploy, call } = require("@completium/completium-cli")

const caller = "tz1VSUr8wwNhLAzempoch5d6hLRiTh8Cjcjb"

const _deploy = async (contract, params) => {
  try {
    const [deployed, _] = await deploy(contract, {
        parameters: params
    })
    return deployed.address
  } catch(e) { 
    console.log(e)
  } 
}

const deploy_greeting_cards = async (owner) => {
  const permits = await _deploy("../contracts/permits.arl", {
    owner
  })

  const greeting_cards = await _deploy("../contracts/greeting-cards.arl", {
    owner,
    admin: owner,
    permits
  })

  return { permits, greeting_cards }
}

const mint_greeting_card = async (greeting_card_contract) => {
  await call(greeting_card_contract, {
    entry: "mint",
    arg: {
      tow: caller,
      tid: 1,
      tmd: [
        { 
          key: "", 
          // This a sample ipfs metadata url and is only used for
          // testing purposes
          value: Buffer.from("ipfs://QmWHPoW3P4Bv889qNB4KH5Ars2toU3mrNb2U5LFiboDGrV").toString("hex") 
        }
      ],
      roy: []
    }
  })
}

const run = async () => {
  const { greeting_cards } = await deploy_greeting_cards()
  await mint_greeting_card(greeting_cards)
}


// Usage with existing deployment. Please udpate contract address after deployment
// Greeting Card on Ghostnet KT1J3Uq6SF8XEiuzrFWCMCPwwdbccBdXoJQh
// https://better-call.dev/ghost/KT1J3Uq6SF8XEiuzrFWCMCPwwdbccBdXoJQh

// KT1UCxGYQkvjBEUm9WJQtEki7souarwFh56k this is a version of the contract where
// the owner (tz2KGsYFe8KqznPaEucRq6YgfmmLRbNcobvb) is our account 
// used for minting in develpment environment
const greeting_card_contract = "KT1J3Uq6SF8XEiuzrFWCMCPwwdbccBdXoJQh"
mint_greeting_card(greeting_card_contract)
