module LocalStorage exposing (get, set, remove, Error(..))

{-|

This library offers rudimentary access to the browser's localStorage, which is
limited to string keys and values. It uses Elm Tasks for storage IO.

# Retrieving
@docs get

# Storing
@docs set

# Removing
@docs remove

-}

import Native.LocalStorage
import String
import Task exposing (Task, andThen, succeed, fail)
import Json.Decode as Json
import Maybe exposing (Maybe(..))


{-|
  Error Object
-}
type Error
  = NoStorage
  | UnexpectedPayload String


{-|

Retrieve the string value for a given key. Yields Maybe.Nothing if the key
does not exist in storage. Task will fail with NoStorage if localStorage is
not available in the browser:

    result : Signal.Mailbox String
    result = Signal.mailbox "loading..."

    main : Signal Element
    main = Signal.map show result.signal

    port getStorage : Task LocalStorage.Error ()
    port getStorage =
      let handle str =
        case str of
          Just s -> Signal.send result.address s
          Nothing -> Signal.send result.address "not found in storage =("
      in
        (LocalStorage.get "some-key")
          `onError` (\_ -> succeed (Just "no localStorage in browser =((("))
          `andThen` handle

-}
get : String -> Task Error (Maybe String)
get =
  Native.LocalStorage.get


{-|

Sets the string value for a given key and passes through the string value as
the task result for chaining. Task will fail with NoStorage if localStorage is
not available in the browser:

    port setStorage : Signal (Task LocalStorage.Error String)
    port setStorage =
      Signal.map (LocalStorage.set storageKey) someStringSignal

-}
set : String -> String -> Task Error String
set =
  Native.LocalStorage.set


{-|

Removes the value for a given key and passes through the string key as the
task result for chaining. Task will fail with NoStorage if localStorage is
not available in the browser:

    port removeStorage : Signal (Task LocalStorage.Error String)
    port removeStorage =
      Signal.map (LocalStorage.remove storageKey) someStringSignal

-}
remove : String -> Task Error String
remove key =
  Native.LocalStorage.remove
