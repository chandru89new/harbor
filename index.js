const { Elm } = require('./main.js');
const { MsgFromElm, MsgToElm } = require('./src/HarborGenerated.js');

const app = Elm.Main.init({
  flags: null,
});

app.ports.fromElm.subscribe(([msgType, data]) => {
  switch (msgType) {
    case MsgFromElm.Log:
      console.log('Asked to Log', data);
      break;
    case MsgFromElm.Store:
      console.log('Asked to Store', data);
      app.ports.toElm.send([MsgToElm.ReceiveString, JSON.stringify('done')]);
      break;
    case MsgFromElm.Get:
      console.log('Asked to Get', data);
      app.ports.toElm.send([MsgToElm.ReceiveBool, JSON.stringify(true)]);
      break;
    default:
      break;
  }
});

setTimeout(() => {
  app.ports.toElm.send([
    MsgToElm.ReceiveBool,
    JSON.stringify({ id: '1', name: 'John' }),
  ]);
}, 4000);
