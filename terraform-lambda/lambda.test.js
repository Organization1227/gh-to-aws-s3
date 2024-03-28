const { handler } = require('./index');

test('should return "Hello, World!"', async () => {
  const event = {}; // Your Lambda event payload
  const result = await handler(event);

  expect(result.statusCode).toBe(200);
  expect(result.body).toBe('"Hello, World!"');
});
