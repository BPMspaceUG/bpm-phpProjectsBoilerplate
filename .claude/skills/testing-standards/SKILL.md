---
name: testing-standards
description: Testing guidelines for PHP and JavaScript. Use when writing tests, fixing test failures, or improving coverage.
allowed-tools: Read, Edit, Bash, Grep
---

# Testing Standards

Comprehensive testing guidelines for the project.

## Test Structure (AAA Pattern)

Every test follows Arrange-Act-Assert:

```php
test('creates user with valid data', function () {
    // Arrange: Set up test data
    $userData = [
        'name' => 'John Doe',
        'email' => 'john@example.com',
        'password' => 'secure123'
    ];

    // Act: Execute the function
    $user = $this->userService->create($userData);

    // Assert: Verify the result
    expect($user)->toBeInstanceOf(User::class);
    expect($user->name)->toBe('John Doe');
    expect($user->email)->toBe('john@example.com');
});
```

## Test Naming

```php
// GOOD - Describes behavior
test('should return 404 when user not found')
test('should hash password before saving')
test('should reject email without @ symbol')
test('should calculate total with tax included')

// BAD - Vague or implementation-focused
test('user test')
test('test1')
test('testCreateMethod')
```

## Coverage Targets

| Layer | Target | Priority |
|-------|--------|----------|
| Services/Logic | 80%+ | HIGH |
| Controllers | 70%+ | HIGH |
| Models | 60%+ | MEDIUM |
| Utilities | 90%+ | HIGH |

## PHP Testing (Pest/PHPUnit)

### Basic Test
```php
test('adds item to cart', function () {
    $cart = new Cart();
    $item = new Item(id: 1, price: 100);

    $cart->add($item);

    expect($cart->items())->toHaveCount(1);
    expect($cart->total())->toBe(100);
});
```

### Database Test
```php
uses(RefreshDatabase::class);

test('creates user in database', function () {
    $user = User::create([
        'name' => 'John',
        'email' => 'john@example.com'
    ]);

    $this->assertDatabaseHas('users', [
        'email' => 'john@example.com'
    ]);
});
```

### API Test
```php
test('GET /users returns user list', function () {
    User::factory()->count(3)->create();

    $response = $this->getJson('/api/users');

    $response->assertStatus(200)
             ->assertJsonCount(3, 'data');
});
```

### Exception Test
```php
test('throws exception for invalid email', function () {
    $service = new UserService();

    expect(fn() => $service->create(['email' => 'invalid']))
        ->toThrow(ValidationException::class);
});
```

## JavaScript Testing (Jest)

```javascript
describe('CartService', () => {
  let cart;

  beforeEach(() => {
    cart = new CartService();
  });

  test('adds item to cart', () => {
    cart.add({ id: 1, price: 100 });

    expect(cart.items).toHaveLength(1);
    expect(cart.total).toBe(100);
  });

  test('calculates total with multiple items', () => {
    cart.add({ id: 1, price: 100 });
    cart.add({ id: 2, price: 50 });

    expect(cart.total).toBe(150);
  });
});
```

## What to Test

### DO Test
- Business logic
- Edge cases (empty, null, max values)
- Error conditions
- Security validations
- API responses

### DON'T Test
- Framework code
- Simple getters/setters
- Private methods directly
- Third-party libraries

## Test Commands

```bash
# Run all tests
./vendor/bin/pest

# Run specific file
./vendor/bin/pest tests/Unit/UserTest.php

# Run with coverage
./vendor/bin/pest --coverage

# Run only failing
./vendor/bin/pest --retry

# Watch mode
npm run test:watch
```

## Debugging Failed Tests

1. Read error message carefully
2. Check test setup (Arrange)
3. Verify mocks are correct
4. Check database state
5. Add debug output: `dump($result);`
6. Run test in isolation
