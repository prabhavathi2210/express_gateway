module.exports = function (gatewayExpressApp) {
  gatewayExpressApp.get('/health', (req, res) => {
    res.json('success');
  });
};