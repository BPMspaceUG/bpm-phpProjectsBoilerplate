---
name: database-patterns
description: Database query patterns and optimization for MariaDB. Use when writing queries, designing schemas, or fixing performance issues.
allowed-tools: Read, Bash
---

# Database Patterns

Efficient database patterns for MariaDB/MySQL.

## Connection (FlightPHP)

```php
// Access via Flight
$db = Flight::db();

// Query methods
$rows = $db->fetchAll('SELECT * FROM users WHERE status = ?', ['active']);
$row = $db->fetchRow('SELECT * FROM users WHERE id = ?', [$id]);
$value = $db->fetchField('SELECT COUNT(*) FROM users');
$db->runQuery('UPDATE users SET status = ? WHERE id = ?', ['active', $id]);
```

## ALWAYS Use Prepared Statements

```php
// ✅ CORRECT - Prepared statement
$user = $db->fetchRow(
    'SELECT * FROM users WHERE email = ?',
    [$email]
);

// ❌ WRONG - SQL Injection!
$user = $db->fetchRow(
    "SELECT * FROM users WHERE email = '$email'"
);
```

## Prevent N+1 Queries

```php
// ❌ N+1 Problem (1 + N queries)
$users = $db->fetchAll('SELECT * FROM users');
foreach ($users as $user) {
    $orders = $db->fetchAll(
        'SELECT * FROM orders WHERE user_id = ?',
        [$user['id']]
    );
}

// ✅ Solution: JOIN (1 query)
$data = $db->fetchAll('
    SELECT u.*, o.id as order_id, o.total
    FROM users u
    LEFT JOIN orders o ON u.id = o.user_id
');

// ✅ Solution: IN clause (2 queries)
$users = $db->fetchAll('SELECT * FROM users');
$userIds = array_column($users, 'id');
$placeholders = str_repeat('?,', count($userIds) - 1) . '?';
$orders = $db->fetchAll(
    "SELECT * FROM orders WHERE user_id IN ($placeholders)",
    $userIds
);
```

## Index Patterns

```sql
-- Primary key (automatic)
CREATE TABLE users (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY
);

-- Foreign keys (ALWAYS index!)
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Frequently queried columns
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);

-- Composite for common WHERE combinations
CREATE INDEX idx_orders_status_date
ON orders(status, created_at);

-- Unique constraint
CREATE UNIQUE INDEX idx_users_email_unique ON users(email);
```

## Pagination

```php
// ✅ CORRECT - With LIMIT
$page = (int)($_GET['page'] ?? 1);
$perPage = 20;
$offset = ($page - 1) * $perPage;

$users = $db->fetchAll(
    'SELECT * FROM users ORDER BY created_at DESC LIMIT ?, ?',
    [$offset, $perPage]
);

// Get total for pagination
$total = $db->fetchField('SELECT COUNT(*) FROM users');

// ❌ WRONG - Fetching all rows
$allUsers = $db->fetchAll('SELECT * FROM users');
$pageUsers = array_slice($allUsers, $offset, $perPage);
```

## Transactions

```php
try {
    $db->beginTransaction();

    $db->runQuery(
        'INSERT INTO orders (user_id, total) VALUES (?, ?)',
        [$userId, $total]
    );
    $orderId = $db->lastInsertId();

    foreach ($items as $item) {
        $db->runQuery(
            'INSERT INTO order_items (order_id, product_id, qty) VALUES (?, ?, ?)',
            [$orderId, $item['product_id'], $item['qty']]
        );
    }

    $db->commit();
} catch (Exception $e) {
    $db->rollBack();
    throw $e;
}
```

## Batch Operations

```php
// ✅ Single query for multiple updates
$db->runQuery(
    'UPDATE products SET is_featured = 0 WHERE is_featured = 1'
);
$db->runQuery(
    'UPDATE products SET is_featured = 1 WHERE id IN (?, ?, ?)',
    [1, 2, 3]
);

// ❌ Loop with individual queries
foreach ($productIds as $id) {
    $db->runQuery('UPDATE products SET is_featured = 1 WHERE id = ?', [$id]);
}
```

## Schema Standards

```sql
CREATE TABLE users (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    status ENUM('active', 'inactive', 'banned') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,

    UNIQUE INDEX idx_users_email (email),
    INDEX idx_users_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

## Debug Queries

```php
// Enable query logging
$db->getAdapter()->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

// Explain slow queries
$explain = $db->fetchAll('EXPLAIN SELECT * FROM orders WHERE status = ?', ['pending']);
```
