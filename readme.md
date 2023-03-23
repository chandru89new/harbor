# Harbor

Type-safety for ports when you want to slap some Elm&lt;-&gt;JS interop quickly.

For a full-fledged Elm&lt;-&gt;TS interop, you should choose [`elm-ts-interop`][elmtsinterop].

[elmtsinterop]: https://elm-ts-interop.com/

## Why does this exist?

I've been writing a lot of personal-use scripts in Elm instead of vanilla JS/TS (because writing with type-safety, in a functional language, is a delightful experience most of the time), and find myself having to write lots of glue-code to get interop between Elm and NodeJS.

One common pattern is a unified port: one port for all incoming data and one port for all outgoing data.

So Harbor exists as a way for me to quickly get type-safe port messages in and out of Elm.

## How to use this?

1. Copy the [`Harbor.elm`](./src/Harbor.elm) file into your project.
2. Define your `PortInMsg` and `PortOutMsg` types. The file already has some good starting points to help you. It's no different from defining custom data types in Elm.
3. Define the `sendHandler`, `receiveHandler` and `portOutMsgToString` functions. Again, follow the lead in the example. The first two are encoders and decoders mostly.
4. Add a `PortMsg` type to your Main `Msg` as show in the [`Main.elm`](./src/Main.elm#L20) file and handle the incoming port msgs the way you want.
5. Add `harborSubscription` to your Main `subscriptions` as shown in the [`Main.elm`](./src/Main.elm#L51) file.
6. To send data out of a port, simply use `Harbor.send` as shown in the example in [`Main.elm`](./src/Main.elm#L27).
7. On the JS side, you can now send/receive a tuple of shape `["PortMsg", data]` where `"PortMsg"` is the string representation of the `PortInMsg` or `PortOutMsg` types. Again, check the [`index.js`](./src/index.js) file to see how that's done.

## Why would I chose this instead of `elm-ts-interop`?

For full-fledged TS/Elm interop, that's the best option. But there maybe some use-cases for just copy-pasting code from Harbor:

- you are prototyping something "quick-n-dirty", or
- you don't want to deal with TS-config for what you are doing, or
- you are writing something simple and dont want to run a generator.
