const { deploy, call } = require("@completium/completium-cli")


const stablecoin_contract = "KT18bZuBJAfEoaKxJMWicGrpzEPoC6mxM9v1"
const caller = "tz1VSUr8wwNhLAzempoch5d6hLRiTh8Cjcjb"

const init_resources = async (pool_address) => {
    try {
      await call(stablecoin_contract, {
        entry: "mint",
        arg: {
          value: 1_000_000
        }
      })

      await call(stablecoin_contract, {
        entry: "transfer",
        arg: {
          from: caller,
          to: pool_address,
          value: 1_000_000
        }
      })
    } catch (e) {
    }
}

const send_gift = async (pool_address) => {
  try {
    await call(pool_address, {
      entry: "send",
      arg: {
        coin_id: 0,
        receiver: "tz1aSkwEot3L2kmUvcoxzjMomb9mvBNuzFK6",
        value: 100
      }
    })
  } catch (e) {
    console.log(e)
  }
}

const deploy_pool = async () => {
  try {
    const [pool, _] = await deploy('../contracts/pool.arl', {
      parameters: { 
        initial_owner: caller,
        stablecoin_contract,
        limit: 1000
      }
    })
    return pool.address
  } catch(e) { 
    console.log(e)
  }
}


async function main() {
  const pool_address = await deploy_pool()
  await init_resources(pool_address)
  await send_gift(pool_address)
}

main()