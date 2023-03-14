const { Elm } = require("./main.js");
const { MsgFromElm, MsgToElm } = require("./example/HarborGenerated.js");

const app = Elm.Main.init({
  flags: null,
});

app.ports.fromElm.subscribe(([msgType, data]) => {
  switch (msgType) {
    case MsgFromElm.LogToConsole:
      console.log("Asked to Log", data);
      break;
    case MsgFromElm.StoreUserInLocal:
      console.log("Asked to Store", data);
      app.ports.toElm.send([MsgToElm.ReceiveString, "done"]);
      break;
    case MsgFromElm.GetUserFromLocal:
      console.log("Asked to Get", data);
      app.ports.toElm.send([MsgToElm.ReceiveBool, true]);
      break;
    default:
      break;
  }
});

setTimeout(() => {
  app.ports.toElm.send([
    MsgToElm.ReceiveUser,
    { id: "1", name: "john", key: "vaue" },
  ]);
}, 4000);
