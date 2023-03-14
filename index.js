const { Elm } = require("./main.js");
const { MsgTypeFromElm } = require("./src/PortTypes.js");

const app = Elm.Main.init({
  flags: null,
});

console.log(app.ports);

app.ports.fromElm.subscribe(([msgType, data]) => {
  switch (msgType) {
    case MsgTypeFromElm.Log:
      console.log("Asked to Log", data);
      break;
    case MsgTypeFromElm.Store:
      console.log("Asked to Store", data);
      app.ports.toElm.send(["ReceiveString", JSON.stringify("done")]);
      break;
    case MsgTypeFromElm.Get:
      console.log("Asked to Get", data);
      app.ports.toElm.send(["ReceiveBool", JSON.stringify(true)]);
      break;
    default:
      break;
  }
});

setTimeout(() => {
  app.ports.toElm.send([
    "ReceiveUser",
    JSON.stringify({ id: "1", name: "John" }),
  ]);
}, 4000);
