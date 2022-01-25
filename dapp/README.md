solc --bin --abi -o ./build first.sol
yarn init -y
yarn global add npx
yarn add web3
# on another terminal 
npx ganache-cli
# back to first terminal
node deploy.js
npx http-server


