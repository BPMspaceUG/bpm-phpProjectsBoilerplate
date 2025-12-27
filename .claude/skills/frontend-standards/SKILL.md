---
name: frontend-standards
description: Frontend coding standards for HTML, CSS, JavaScript, and DataTables. Use when building UI, styling, or implementing tables.
allowed-tools: Read, Grep, Glob
---

# Frontend Standards

Standards for HTML, CSS, JavaScript, and UI components.

## MANDATORY: DataTables for ALL Tables

**NO plain HTML tables!** Every table MUST use DataTables.

### Basic Setup
```html
<!-- In layout head -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.dataTables.min.css">

<!-- Before closing body -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
```

### Standard Table
```javascript
$('#myTable').DataTable({
    responsive: true,
    pageLength: 25,
    order: [[0, 'desc']],
    language: {
        url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/de-DE.json'
    }
});
```

### Server-Side (Large Data)
```javascript
$('#myTable').DataTable({
    processing: true,
    serverSide: true,
    ajax: {
        url: '/api/data',
        type: 'POST'
    },
    columns: [
        { data: 'id' },
        { data: 'name' },
        { data: 'email' },
        {
            data: null,
            render: function(data) {
                return `<a href="/users/${data.id}">View</a>`;
            }
        }
    ]
});
```

## HTML Standards

### Semantic Elements
```html
<!-- ✅ CORRECT -->
<header>...</header>
<nav>...</nav>
<main>
    <article>...</article>
    <aside>...</aside>
</main>
<footer>...</footer>

<!-- ❌ WRONG -->
<div class="header">...</div>
<div class="nav">...</div>
<div class="main">...</div>
```

### Accessibility
```html
<!-- Images need alt text -->
<img src="user.jpg" alt="User profile photo">

<!-- Forms need labels -->
<label for="email">Email</label>
<input type="email" id="email" name="email" required>

<!-- Buttons need accessible text -->
<button type="submit" aria-label="Submit form">
    <i class="icon-send"></i>
</button>
```

## CSS Standards

### Mobile First
```css
/* Base: Mobile */
.container {
    padding: 1rem;
}

/* Tablet: 768px+ */
@media (min-width: 768px) {
    .container {
        padding: 2rem;
    }
}

/* Desktop: 1024px+ */
@media (min-width: 1024px) {
    .container {
        max-width: 1200px;
        margin: 0 auto;
    }
}
```

### Naming (BEM)
```css
/* Block */
.card { }

/* Element */
.card__header { }
.card__body { }
.card__footer { }

/* Modifier */
.card--featured { }
.card--disabled { }
```

### Variables
```css
:root {
    --color-primary: #3498db;
    --color-secondary: #2ecc71;
    --color-danger: #e74c3c;
    --spacing-sm: 0.5rem;
    --spacing-md: 1rem;
    --spacing-lg: 2rem;
}

.button {
    background: var(--color-primary);
    padding: var(--spacing-sm) var(--spacing-md);
}
```

## JavaScript Standards

### ES6+ Syntax
```javascript
// Arrow functions
const calculate = (a, b) => a + b;

// Template literals
const message = `Hello, ${user.name}!`;

// Destructuring
const { id, name, email } = user;

// Spread operator
const updated = { ...user, status: 'active' };

// Async/await
async function fetchUsers() {
    const response = await fetch('/api/users');
    return response.json();
}
```

### Event Handling
```javascript
// Use event delegation for dynamic content
document.querySelector('#userList').addEventListener('click', (e) => {
    if (e.target.matches('.delete-btn')) {
        const userId = e.target.dataset.id;
        deleteUser(userId);
    }
});
```

## Latte Templates

```latte
{* Always escape (automatic in Latte) *}
{$user->name}

{* Explicit escape for attributes *}
<input value="{$user->name}">

{* Loop with DataTable *}
<table id="usersTable" class="display responsive">
    <thead>
        <tr>
            <th>Name</th>
            <th>Email</th>
        </tr>
    </thead>
    <tbody>
        {foreach $users as $user}
        <tr>
            <td>{$user->name}</td>
            <td>{$user->email}</td>
        </tr>
        {/foreach}
    </tbody>
</table>

{block scripts}
<script>
$('#usersTable').DataTable({ responsive: true });
</script>
{/block}
```

## Forbidden

1. ❌ Plain HTML tables (use DataTables!)
2. ❌ Inline styles for layouts
3. ❌ Non-semantic HTML
4. ❌ Missing alt text on images
5. ❌ jQuery for simple DOM operations
6. ❌ `var` keyword (use `const`/`let`)
