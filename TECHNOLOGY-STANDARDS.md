# Technology Standards for All Projects

**MANDATORY** standards for all projects using this boilerplate.

---

## Core Framework: FlightPHP v3

### Official Documentation
- **Main Docs**: https://docs.flightphp.com/en/v3/
- **Skeleton**: https://github.com/flightphp/skeleton
- **Awesome Plugins**: https://docs.flightphp.com/en/v3/awesome-plugins

### Required Plugins (MUST USE)

#### 1. Async Plugin
- **Docs**: https://docs.flightphp.com/en/v3/awesome-plugins/async
- Use for background tasks, parallel processing

#### 2. Permissions Plugin
- **Docs**: https://docs.flightphp.com/en/v3/awesome-plugins/permissions
- Use for all authorization logic

### Installation
```bash
composer require flightphp/core
composer require flightphp/permissions
```

---

## Template Engine

### DEPRECATED (DO NOT USE)
```
flightphp/core View
```
> This is a very basic templating engine that is part of the core.
> It's NOT recommended if you have more than a couple pages in your project.

### RECOMMENDED: Latte
```bash
composer require latte/latte
```
- Full featured templating engine
- PHP-like syntax (easier than Twig)
- Easy to extend with custom filters/functions
- **Docs**: https://latte.nette.org/

### ALTERNATIVE: CommentTemplate
```bash
composer require knifelemon/comment-template
```
- Powerful PHP template engine
- Asset compilation (CSS/JS minification)
- Template inheritance
- Optional Flight PHP integration
- **Docs**: https://github.com/knifelemon/comment-template

---

## DataTables - ABSOLUTE MUST

### MANDATORY FOR ALL TABLES
- **Website**: https://datatables.net
- **Docs**: https://datatables.net/manual/

### Rules
1. **NO plain HTML tables** - Every table MUST use DataTables
2. Use server-side processing for large datasets
3. Include search, sort, pagination by default

### Basic Integration
```html
<!-- CSS -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">

<!-- JS -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>

<script>
$(document).ready(function() {
    $('#myTable').DataTable();
});
</script>
```

### Server-Side Example
```javascript
$('#myTable').DataTable({
    processing: true,
    serverSide: true,
    ajax: '/api/data'
});
```

---

## Coding Standards

### PHP
- PSR-12 coding style
- Type hints for all parameters and return types
- Namespace all classes

### File Organization
```
www/
├── app/
│   ├── config/          # Configuration files
│   ├── controllers/     # Request handlers
│   ├── middlewares/     # Request/Response middleware
│   ├── models/          # Data models
│   ├── services/        # Business logic
│   └── views/           # Latte templates
├── public/              # Webroot (only public files!)
│   ├── index.php        # Entry point
│   ├── css/
│   ├── js/
│   └── images/
└── composer.json
```

### Forbidden Practices
1. NO inline SQL - use prepared statements
2. NO hardcoded credentials - use .env files
3. NO plain HTML tables - use DataTables
4. NO flightphp/core View - use Latte
5. NO version zoo (*_v2.php, *_backup.php)

---

## Project Checklist

Before deploying, verify:

- [ ] FlightPHP v3 installed
- [ ] Latte (or CommentTemplate) for templates
- [ ] Permissions plugin for auth
- [ ] ALL tables use DataTables
- [ ] No plain HTML tables
- [ ] No hardcoded passwords
- [ ] .env files not in git
- [ ] PSR-12 coding style
- [ ] All scripts follow cont_*/ext_* naming

---

## Quick Reference Links

| Technology | URL |
|-----------|-----|
| FlightPHP Docs | https://docs.flightphp.com/en/v3/ |
| FlightPHP Skeleton | https://github.com/flightphp/skeleton |
| FlightPHP Plugins | https://docs.flightphp.com/en/v3/awesome-plugins |
| Async Plugin | https://docs.flightphp.com/en/v3/awesome-plugins/async |
| Permissions | https://docs.flightphp.com/en/v3/awesome-plugins/permissions |
| DataTables | https://datatables.net |
| Latte Templates | https://latte.nette.org/ |
