# isomorfeus-redux

Redux for Opal Ruby.

### Community and Support
At the [Isomorfeus Framework Project](http://isomorfeus.com) 

## Versioning
isomorfeus-redux version follows the Redux version which features and API it implements.
Isomorfeus-redux 4.0.x implements features and the API of Redux 4.0 and should be used with Redux 4.0

## Installation
To install redux with the matching version:
```
yarn add redux@4.0.5
```
then add to the Gemfile:
```ruby
gem 'isomorfeus-redux'
```
then `bundle install`
and to your client code add:
```ruby
require 'isomorfeus-redux'
```

### Dependencies

For full functionality the following are required:
- [Opal ES6 import export](https://github.com/opal/opal/pull/1976)
- [Opal Webpack Loader](https://github.com/janbiedermann/opal-webpack-loader)
- [Opal Autoloader](https://github.com/janbiedermann/opal-autoloader)

For the Gemfile:
```ruby
gem 'opal', github: 'janbiedermann/opal', branch: 'es6_modules_1_1'
gem 'opal-webpack-loader', '~> 0.9.10'
```

## Usage within Isomorfeus

Lucid Components have store access integrated, see the isomorfeus-react documentation.

The following stores are available:
- AppStore - reactive store managed by redux
- LocalStore - convenient access to the Browsers localStorage, changes from within ruby can be subscribed to
- SessionStore - convenient access to the Browsers sessionStorage, changes from within ruby can be subscribed to

### AppStore
All keys must be Strings or Symbols! All values must be serializable, simple types preferred!

Example Usage:
```ruby
# setting a value:
AppStore.some_key = 10
AppStore[:some_key] = 10
AppStore.set(:some_key, 10) 
AppStore.promise_set(:some_key, 10)

# getting a value:
val = AppStore.some_key
val = AppStore[:some_key]
val = AppStore.get(:some_key) 
AppStore.promise_get(:some_key).then do |val|
  # do something
end

# subscribing to changes
unsub = AppStore.subscribe do
  @val = AppStore.some_key
end

# MUST be unsibscribed if changes are no longer wanted
AppStore.unsubscribe(unsub) 
```

### LocalStore
All keys and values must be Strings or Symbols!

```ruby
# setting a value:
LocalStore.some_key = 10
LocalStore[:some_key] = 10
LocalStore.set(:some_key, 10) 
LocalStore.promise_set(:some_key, 10)

# getting a value:
val = LocalStore.some_key
val = LocalStore[:some_key]
val = LocalStore.get(:some_key) 
LocalStore.promise_get(:some_key).then do |val|
  # do something
end

# deleting a value
LocalStore.delete(:some_key)
LocalStore.promise_delete(:some_key)

# clearing the store
LocalStore.clear 
LocalStore.promise_clear

# subscribing to changes
unsub = LocalStore.subscribe do
  @val = LocalStore.some_key
end

# MUST be unsibscribed if changes are no longer wanted
LocalStore.unsubscribe(unsub) 
```

### SessionStore
All keys and values must be Strings or Symbols!

```ruby
# setting a value:
SessionStore.some_key = 10
SessionStore[:some_key] = 10
SessionStore.set(:some_key, 10) 
SessionStore.promise_set(:some_key, 10)

# getting a value:
val = SessionStore.some_key
val = SessionStore[:some_key]
val = SessionStore.get(:some_key) 
SessionStore.promise_get(:some_key).then do |val|
  # do something
end

# deleting a value
SessionStore.delete(:some_key)
SessionStore.promise_delete(:some_key)

# clearing the store
SessionStore.clear 
SessionStore.promise_clear

# subscribing to changes
unsub = SessionStore.subscribe do
  @val = SessionStore.some_key
end

# MUST be unsibscribed if changes are no longer wanted
LocalStore.unsubscribe(unsub) 
```

## Advanced Usage
Because isomorfeus-redux follows closely the Redux principles/implementation/API and Documentation, most things of the official Redux documentation
apply, but in the Ruby way, see:
- https://redux.js.org

Redux and accompanying libraries must be imported and available in the global namespace in the application javascript entry file,
with webpack this can be ensured by assigning them to the global namespace:
```javascript
import * as Redux from 'redux';
global.Redux = Redux;
```

Following features are presented with its differences to the Javascript Redux implementation.
Of course, in Ruby the naming is underscored, eg. `Redux.createStore` in javascript becomes `Redux.create_store` in Ruby.

### Creating a Store
A store can be created using:
```ruby
store = Redux::Store.new(reducer, preloaded_state, enhancer)
```
or:
```ruby
store = Redux.create_store(reducer, preloaded_state, enhancer)
```
- **reducer** is a javascript function. Isomorfeus provides a helper to create a reducer, see below.
- **preloaded_state** can be a Ruby Hash or a native javascript object.
- **enhancer** is a javascript function.

### Creating a Reducer
Its possible to use native javascript functions for creating a store. To use ruby conveniently for reducers a helper is provided:
```ruby
reducer = Redux.create_reducer do |prev_state, action|
  # do something here 
  {}.merge(prev_state) 
end
```
This helper wraps the ruby code block in a javascript function that takes care of converting Opal Hashes to javascript
objects and the other way around. The resulting reducer is simply javascript function, suitable for creating a store.

### Adding a reducer to the global store
The reducer must be a Javascript function and can be created with Redux.create_reducer as above:
```ruby
Redux::Store.add_reducer(your_store_key_name: reducer)
```

### Global Store
The store is available from anywhere within Opal Ruby context as:
```ruby
Isomorfeus.store
```
To get the native store from within Javascript context:
```javascript
Opal.Isomorfeus.store.native
```

### Other Rubyfications
- `dispatch` accepts a Ruby Hash
- `get_state` returns a Ruby Hash
- `subscribe` accepts a ruby block as listener:
```ruby
Isomorfeus.store.subscribe do
  # something useful here
end
```

### Setup
If isomorfeus-redux is used in isolation, these methods can be used:
```ruby
Redux::Store.add_middleware(middleware) # middleware must be Javascript function
Redux::Store.init! # initializes the global store
```

### Development Tools
The Redux Development Tools allow for detailed debugging of store/state changes: https://github.com/zalmoxisus/redux-devtools-extension

### Specs
Specs for the stores are in isomorfeus-react.
