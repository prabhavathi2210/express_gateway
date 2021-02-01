module.exports = {
  version: '1.2.0',
  init: function (pluginContext) {
    pluginContext.registerGatewayRoute(require('./health'));
  }
}