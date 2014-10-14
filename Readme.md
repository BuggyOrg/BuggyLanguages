# BuggyLanguages

The BuggyLanguages package enables the support of different input languages 
for Buggy. With this package it is possible to write Buggy Dataflow descriptors
in different languages. This is only an utility package that displays 
Buggy Implementations in a different way. The code written in the Language
usually doesn't get compiled. Only the AST is used.

This package supports registering languages and delivers a LiveScript support.

## Installation

Currently you have to clone the repository in order to use it. You will need
NodeJS and NPM to install everything. After that you have to link the Buggy 
repository via

```npm link <path to buggy repo>```

as long as it isn't published to the public NPM Repository. Now you can install
all dependencies via

```npm install```

You should install grunt globally via `npm install -g grunt` and then you can
build everything with

```grunt build```

This will pack everything into a single file `build/languages.js`


## Public API

To use this package simply require it (e.g. via `BuggyLanguages = require("BuggyLanguages");`)
or include it in you HTML file. The API is

* `languages()`: Lists all supported languages as an Array of Strings
* `transpiler(from,to)`: Returns a Transpiler, a function that can convert from
 language `from` to  `to`. Returns `null` if it is not possible to build such a 
 Transpiler with the given Languages
* `register(language)`: Registers the Language to the BuggyLanguage System
 (It is stored globally).
* `unregister(langName)`: Removes the Language with the name `langName` from the
 registry.

## Designing a new Language

Designing a new language is rather simple. The Language is a Javascript Object
that contains two methods `generate` and `parse`. Where `generate` creates the 
source code for a given Implementation / Dataflow. Whereas `parse` can create the
Buggy Implementation / Dataflow from the code. Furthermore every language needs
a `name`.

There is one important restriction for every language. The composition of
`generate` and `parse` (creating source for an implementation and converting this
 back to an implementation) must be the identity! This may not hold for the
composition of `parse` and `generate` as whitespaces might vary.

## License

Buggy and all it's parts (including BuggyLanguages) are released under GPL v3, 
see the License file (https://raw.githubusercontent.com/BuggyOrg/BuggyLanguages/master/LICENSE).
