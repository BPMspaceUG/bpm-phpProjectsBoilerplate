---
name: php-standards
description: PHP coding standards for FlightPHP projects. Use when writing PHP code, reviewing code, or understanding project conventions.
allowed-tools: Read, Grep, Glob
---

# PHP Coding Standards

Standards for all PHP code in FlightPHP projects.

## PSR-12 Style

```php
<?php

declare(strict_types=1);

namespace app\controllers;

use app\logic\UserService;
use Flight;

class UserController
{
    private UserService $userService;

    public function __construct(UserService $userService)
    {
        $this->userService = $userService;
    }

    public function index(): void
    {
        $users = $this->userService->getAllActive();
        Flight::json($users);
    }

    public function show(int $id): void
    {
        $user = $this->userService->findById($id);

        if ($user === null) {
            Flight::halt(404, 'User not found');
            return;
        }

        Flight::json($user);
    }
}
```

## Type Hints

```php
// Parameters and return types REQUIRED
public function createUser(string $name, string $email): User

// Nullable types
public function findById(int $id): ?User

// Union types (PHP 8+)
public function process(string|int $id): void

// Array type hints with docblock
/**
 * @param array<int, User> $users
 * @return array<string, mixed>
 */
public function processUsers(array $users): array
```

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Classes | PascalCase | `UserController` |
| Methods | camelCase | `getUserById` |
| Variables | camelCase | `$userName` |
| Constants | UPPER_SNAKE | `MAX_ATTEMPTS` |
| Properties | camelCase | `$isActive` |

## FlightPHP Specific

### Routes
```php
// app/config/routes.php
Flight::route('GET /users', [UserController::class, 'index']);
Flight::route('GET /users/@id:[0-9]+', [UserController::class, 'show']);
Flight::route('POST /users', [UserController::class, 'create']);
```

### Configuration
```php
// app/config/config.php - NO .env FILES!
return [
    'database' => [
        'host' => 'localhost',
        'name' => 'myapp',
        'user' => 'myapp',
        'pass' => 'secret'
    ]
];
```

### Namespaces
```php
// Match directory structure, lowercase
namespace app\controllers;
namespace app\logic;
namespace app\middlewares;
```

## Security Rules

1. **Always escape output** (Latte does this automatically)
2. **Always use prepared statements**
3. **Always validate input**
4. **Never trust user data**
5. **Hash passwords with PASSWORD_DEFAULT**

## Documentation

```php
/**
 * Creates a new user account.
 *
 * @param string $email User's email address
 * @param string $password Plain text password (will be hashed)
 * @return User The created user
 * @throws ValidationException If email is invalid
 * @throws DuplicateEntryException If email exists
 */
public function createUser(string $email, string $password): User
```
