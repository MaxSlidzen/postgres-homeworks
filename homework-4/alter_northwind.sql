-- Подключиться к БД Northwind и сделать следующие изменения:
-- 1. Добавить ограничение на поле unit_price таблицы products (цена должна быть больше 0)
ALTER TABLE products ADD CONSTRAINT chk_unit_price CHECK (unit_price > 0);

-- 2. Добавить ограничение, что поле discontinued таблицы products может содержать только значения 0 или 1
ALTER TABLE products ADD CONSTRAINT chk_discontinued CHECK (discontinued IN (0, 1));

-- 3. Создать новую таблицу, содержащую все продукты, снятые с продажи (discontinued = 1)
SELECT * INTO discontinued_products FROM products
WHERE (discontinued = 1);

-- 4. Удалить из products товары, снятые с продажи (discontinued = 1)
-- Для 4-го пункта может потребоваться удаление ограничения, связанного с foreign_key. Подумайте, как это можно решить, чтобы связь с таблицей order_details все же осталась.

-- Создание таблицы, содержащей краткую информацию о всех продуктах без исключения
SELECT product_id, product_name INTO all_products FROM products;
ALTER TABLE all_products ADD CONSTRAINT pk_all_products PRIMARY KEY(product_id);

-- Добавление в таблицу товаров, снятых с продажи точно таких же ограничений, как и в начальной таблице продуктов (для возможности корректного продолжения работы с БД),
-- а также внешнего ключа с ссылкой на таблицу all_products
BEGIN;
    ALTER TABLE discontinued_products ADD CONSTRAINT pk_disc_products PRIMARY KEY(product_id);
    ALTER TABLE discontinued_products ADD CONSTRAINT fk_disc_products_categories FOREIGN KEY (category_id) REFERENCES categories;
    ALTER TABLE discontinued_products ADD CONSTRAINT fk_disc_products_suppliers FOREIGN KEY (supplier_id) REFERENCES suppliers;
    ALTER TABLE discontinued_products ADD CONSTRAINT fk_disc_products_id FOREIGN KEY(product_id) REFERENCES all_products(product_id);
    ALTER TABLE discontinued_products ADD CONSTRAINT chk_unit_price CHECK (unit_price > 0);
    ALTER TABLE discontinued_products ADD CONSTRAINT chk_discontinued CHECK (discontinued IN (0, 1));

    -- Переопределение внешнего ключа
    ALTER TABLE order_details DROP CONSTRAINT fk_order_details_products;
    ALTER TABLE order_details ADD CONSTRAINT fk_order_details_products FOREIGN KEY(product_id) REFERENCES all_products(product_id);

    -- Добавление внешнего внешнего ключа с ссылкой на таблицу all_products
    ALTER TABLE products ADD CONSTRAINT fk_products_id FOREIGN KEY(product_id) REFERENCES all_products(product_id);

    -- Удаление необходимых строк из таблицы
    DELETE FROM products WHERE discontinued = 1;
COMMIT;