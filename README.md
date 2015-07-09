gulp & coffee boilerplate
==================

Simple gulp boilerplate for front-end development.


## Features
* Live-reload
* Image optimization
* Compile Scss files
* Autoprefix styles
* Compile Coffee scripts files
* Support require of [bower](http://bower.io/) and [npm](https://www.npmjs.com/) modules
* JS and CSS compression


## Instal
```
$ git clone https://github.com/tsuyoshiwada/gulp-coffee-boilerplate.git
$ cd coffee-boilerplate
$ npm install && bower install
```


## Usage

### Start development
```
$ gulp
# or
$ gulp watch
```

### Create a build files
```
$ gulp build
# or
$ gulp build --env production
```

If you pass an environment variable to generate a file for production.

