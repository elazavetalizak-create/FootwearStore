-- Контрольные запросы после импорта данных.
USE shoe_store_work;

-- 1. Фактическое и ожидаемое количество строк.
SELECT 'categories' AS table_name, COUNT(*) AS actual_rows, 2 AS expected_rows FROM categories
UNION ALL SELECT 'manufacturers', COUNT(*), 6 FROM manufacturers
UNION ALL SELECT 'suppliers', COUNT(*), 2 FROM suppliers
UNION ALL SELECT 'products', COUNT(*), 30 FROM products
UNION ALL SELECT 'roles', COUNT(*), 3 FROM roles
UNION ALL SELECT 'users', COUNT(*), 10 FROM users
UNION ALL SELECT 'pvz', COUNT(*), 36 FROM pvz
UNION ALL SELECT 'orderstatus', COUNT(*), 2 FROM orderstatus
UNION ALL SELECT 'orders', COUNT(*), 10 FROM orders
UNION ALL SELECT 'prodorders', COUNT(*), 20 FROM prodorders;

-- 2. Проверка ссылок товаров на справочники.
SELECT p.id, p.article, p.category_id
FROM products p LEFT JOIN categories c ON c.id = p.category_id
WHERE c.id IS NULL;

SELECT p.id, p.article, p.manufacturer_id
FROM products p LEFT JOIN manufacturers m ON m.id = p.manufacturer_id
WHERE m.id IS NULL;

SELECT p.id, p.article, p.supplier_id
FROM products p LEFT JOIN suppliers s ON s.id = p.supplier_id
WHERE s.id IS NULL;

-- 3. Проверка ссылок заказов.
SELECT o.id, o.user_id
FROM orders o LEFT JOIN users u ON u.id = o.user_id
WHERE u.id IS NULL;

SELECT o.id, o.pvz_id
FROM orders o LEFT JOIN pvz v ON v.id = o.pvz_id
WHERE v.id IS NULL;

-- 4. Просмотр каталога через JOIN.
SELECT p.article, p.name, c.name AS category,
       m.name AS manufacturer, s.name AS supplier,
       p.price, p.discount, p.stock_qty
FROM products p
JOIN categories c ON c.id = p.category_id
JOIN manufacturers m ON m.id = p.manufacturer_id
JOIN suppliers s ON s.id = p.supplier_id
ORDER BY p.name;
