# es-npm
A command line tool to create npm compatible Espresso packages.

## Install
````sh
npm i -g @eslang/es-npm
````

## Usage
````sh
mkdir my-espresso-app
cd my-espresso-app
es-npm init [default|app|module|web|site] [-c|--compact]  [-d|--dev]
````
### Templates
- default - A project serves in both app and module modes..
- app - A project only serves as an app.
- module - A project only serves as a module.
- web - A web app project contains both pages and a RESTful service.
- site - A web site project only hosts web pages.
- api - A project serves as a RESTful service.

### Options
- -c, --compact: remove test code and dependency on mocha.
- -d, --dev: use development (non-published & unstable) branch of eslang.
