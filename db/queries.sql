-- SQL-запросы для приложения магазина обуви
-- СУБД: MySQL 8.0+
-- ? — позиционный параметр MySqlCommand; значения передаются отдельно.

USE shoe_store_work;

-- 1. Авторизация: параметры login, password.
SELECT u.id, u.full_name, r.name AS role_name
FROM users AS u
INNER JOIN roles AS r ON r.id = u.role_id
WHERE u.login = ? AND u.password = ?
LIMIT 1;

-- 2. Каталог товаров.
SELECT p.id, p.article, p.name, p.unit, p.price, p.discount,
       ROUND(p.price * (100 - p.discount) / 100, 2) AS final_price,
       p.stock_qty, p.description, p.photo,
       c.name AS category_name, m.name AS manufacturer_name,
       s.name AS supplier_name
FROM products AS p
INNER JOIN categories AS c ON c.id = p.category_id
INNER JOIN manufacturers AS m ON m.id = p.manufacturer_id
INNER JOIN suppliers AS s ON s.id = p.supplier_id
ORDER BY p.name, p.article;

-- 3. Поиск + фильтр поставщика + сортировка по возрастанию остатка.
-- Параметры: search_text, supplier_id, supplier_id.
-- Для всех поставщиков передать NULL в оба параметра фильтра.
SELECT p.id, p.article, p.name, p.unit, p.price, p.discount,
       ROUND(p.price * (100 - p.discount) / 100, 2) AS final_price,
       p.stock_qty, p.description, p.photo,
       c.name AS category_name, m.name AS manufacturer_name,
       s.name AS supplier_name
FROM products AS p
INNER JOIN categories AS c ON c.id = p.category_id
INNER JOIN manufacturers AS m ON m.id = p.manufacturer_id
INNER JOIN suppliers AS s ON s.id = p.supplier_id
WHERE CONCAT_WS(' ', p.article, p.name, p.unit, p.description,
                c.name, m.name, s.name) LIKE CONCAT('%', ?, '%')
  AND (? IS NULL OR p.supplier_id = ?)
ORDER BY p.stock_qty ASC, p.name ASC;

-- 4. Тот же поиск и фильтр, сортировка по убыванию остатка.
SELECT p.id, p.article, p.name, p.unit, p.price, p.discount,
       ROUND(p.price * (100 - p.discount) / 100, 2) AS final_price,
       p.stock_qty, p.description, p.photo,
       c.name AS category_name, m.name AS manufacturer_name,
       s.name AS supplier_name
FROM products AS p
INNER JOIN categories AS c ON c.id = p.category_id
INNER JOIN manufacturers AS m ON m.id = p.manufacturer_id
INNER JOIN suppliers AS s ON s.id = p.supplier_id
WHERE CONCAT_WS(' ', p.article, p.name, p.unit, p.description,
                c.name, m.name, s.name) LIKE CONCAT('%', ?, '%')
  AND (? IS NULL OR p.supplier_id = ?)
ORDER BY p.stock_qty DESC, p.name ASC;

-- 5. Данные для ComboBox.
SELECT id, name FROM categories ORDER BY name;
SELECT id, name FROM manufacturers ORDER BY name;
SELECT id, name FROM suppliers ORDER BY name;

-- 6. Добавление товара.
INSERT INTO products (
    article, name, unit, price, discount, stock_qty,
    description, photo, category_id, manufacturer_id, supplier_id
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);

-- 7. Загрузка товара для редактирования.
SELECT id, article, name, unit, price, discount, stock_qty,
       description, photo, category_id, manufacturer_id, supplier_id
FROM products WHERE id = ?;

-- 8. Сохранение изменений. Последний параметр — ID товара.
UPDATE products
SET article = ?, name = ?, unit = ?, price = ?, discount = ?,
    stock_qty = ?, description = ?, photo = ?, category_id = ?,
    manufacturer_id = ?, supplier_id = ?
WHERE id = ?;

-- 9. Проверка использования товара в заказах перед удалением.
SELECT COUNT(*) AS used_in_orders
FROM prodorders WHERE product_id = ?;

-- 10. Удаление разрешать только при used_in_orders = 0.
DELETE FROM products WHERE id = ?;
