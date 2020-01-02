# Terraform Lambda Typescript Starter 🏗λ
This is a basic Hello World starter template that utilises terraform for provisioning cloud resources. It is an opionanted starter which 
uses TypeScript, ESlint, Prettier and Husky.

## Usage 🔬
*Currently being consumed by these project(s) of mine, will try and keep this list updated*
- [Serverless Weather 🌦](https://github.com/rahman95/serverless-weather)

## Tech 🧰
- Terraform
- Typescript
- ESLint
- Prettier
- Husky

## What gets provisioned? 🔍
- API Gateway
- Lambda
- KMS Setup

## Deployment 🚀
- Run `yarn lint` to lint TS code using both ESLint and Prettier working together
- Run `yarn script:build-dependency-layer` this will run a bash script to zip up production dependencies and add them to the lamba as a layer
- Run `yarn build` to run TSC to compile TS code to plain JS
- Run `yarn cleanup` to remove generated files after deployment steps
- Run `yarn tf:init` to get aws provider plugin downloaded
- Run `yarn tf:plan` to see changes that will be made
- Run `yarn tf:apply` to actually make those changes to your provider
- Visit AWS and see all your services provisioned via terraform
- Run `yarn tf:destroy` to destroy all the services that were built

You can also simply call `yarn deploy:all` to both zip up an archive and provision the resources together. Similarly you could run `yarn update:all` to destroy all resources and re-provision them.