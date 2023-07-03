-- 1. Создать таблицу student с полями student_id serial, first_name varchar, last_name varchar, birthday date, phone varchar
CREATE TABLE student
(
	student_id serial PRIMARY KEY,
	first_name varchar,
	last_name varchar,
	birthday date,
	phone varchar
)

-- 2. Добавить в таблицу student колонку middle_name varchar
ALTER TABLE student ADD COLUMN middle_name varchar

-- 3. Удалить колонку middle_name
ALTER TABLE student DROP COLUMN middle_name

-- 4. Переименовать колонку birthday в birth_date
ALTER TABLE student RENAME birthday TO birth_date

-- 5. Изменить тип данных колонки phone на varchar(32)
ALTER TABLE student ALTER COLUMN phone SET DATA TYPE varchar(32)

-- 6. Вставить три любых записи с автогенерацией идентификатора
INSERT INTO student (first_name, last_name, birth_date, phone) VALUES
('Ivanov', 'Ivan', '1999-12-27', '8-900-132-76'),
('Petrov', 'Petr', '2000-03-15', '8-900-132-77'),
('Sidorov', 'Fedor', '1999-09-23', '8-900-132-78')

-- 7. Удалить все данные из таблицы со сбросом идентификатор в исходное состояние
TRUNCATE student RESTART IDENTITY
