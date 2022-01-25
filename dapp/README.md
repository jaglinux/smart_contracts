solc --bin --abi -o ./build first.sol <br />
yarn init -y <br />
yarn global add npx <br />
yarn add web3 <br />
# on another terminal  
npx ganache-cli <br />
# back to first terminal 
node deploy.js <br />
npx http-server <br />

# credits https://medium.com/compound-finance/setting-up-an-ethereum-development-environment-7c387664c5fe
