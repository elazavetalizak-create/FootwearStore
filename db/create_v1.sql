-- Проект: учебная БД магазина обуви
-- СУБД: MySQL 8.0+
-- Черновая основа: перед сдачей сверить типы и FK с моделью .mwb.

CREATE DATABASE IF NOT EXISTS shoe_store_work
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE shoe_store_work;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS prodorders;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS pvz;
DROP TABLE IF EXISTS orderstatus;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS manufacturers;
DROP TABLE IF EXISTS categories;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE categories (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_categories_name (name)
) ENGINE=InnoDB;

CREATE TABLE manufacturers (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_manufacturers_name (name)
) ENGINE=InnoDB;

CREATE TABLE suppliers (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_suppliers_name (name)
) ENGINE=InnoDB;

CREATE TABLE products (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    article VARCHAR(30) NOT NULL,
    name VARCHAR(150) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    discount TINYINT UNSIGNED NOT NULL DEFAULT 0,
    stock_qty INT UNSIGNED NOT NULL DEFAULT 0,
    description TEXT NULL,
    photo VARCHAR(255) NULL,
    category_id INT UNSIGNED NOT NULL,
    manufacturer_id INT UNSIGNED NOT NULL,
    supplier_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_products_article (article),
    KEY ix_products_category (category_id),
    KEY ix_products_manufacturer (manufacturer_id),
    KEY ix_products_supplier (supplier_id),
    CONSTRAINT chk_products_price CHECK (price >= 0),
    CONSTRAINT chk_products_discount CHECK (discount BETWEEN 0 AND 100),
    CONSTRAINT fk_products_category FOREIGN KEY (category_id)
        REFERENCES categories(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_products_manufacturer FOREIGN KEY (manufacturer_id)
        REFERENCES manufacturers(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_products_supplier FOREIGN KEY (supplier_id)
        REFERENCES suppliers(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE roles (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_roles_name (name)
) ENGINE=InnoDB;

CREATE TABLE users (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(160) NOT NULL,
    login VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_users_login (login),
    KEY ix_users_role (role_id),
    CONSTRAINT fk_users_role FOREIGN KEY (role_id)
        REFERENCES roles(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE pvz (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    postcode VARCHAR(12) NOT NULL,
    city VARCHAR(80) NOT NULL,
    street VARCHAR(120) NOT NULL,
    house VARCHAR(20) NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE orderstatus (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_orderstatus_name (name)
) ENGINE=InnoDB;

CREATE TABLE orders (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_date DATE NOT NULL,
    delivery_date DATE NULL,
    pvz_id INT UNSIGNED NOT NULL,
    user_id INT UNSIGNED NOT NULL,
    receive_code VARCHAR(20) NOT NULL,
    status_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (id),
    KEY ix_orders_pvz (pvz_id),
    KEY ix_orders_user (user_id),
    KEY ix_orders_status (status_id),
    CONSTRAINT fk_orders_pvz FOREIGN KEY (pvz_id)
        REFERENCES pvz(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_orders_status FOREIGN KEY (status_id)
        REFERENCES orderstatus(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE prodorders (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    qty INT UNSIGNED NOT NULL,
    PRIMARY KEY (id),
    KEY ix_prodorders_order (order_id),
    KEY ix_prodorders_product (product_id),
    CONSTRAINT chk_prodorders_qty CHECK (qty > 0),
    CONSTRAINT fk_prodorders_order FOREIGN KEY (order_id)
        REFERENCES orders(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_prodorders_product FOREIGN KEY (product_id)
        REFERENCES products(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- После создания проверьте, что получились 10 таблиц.
