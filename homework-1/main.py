"""Скрипт для заполнения данными таблиц в БД Postgres."""
import psycopg2
import csv
import os

# Персональный пароль для работы с postgres
PASSWORD = os.getenv('psql_password')

# Переменные для пути к файлам csv
customers_path = 'north_data/customers_data.csv'
employees_path = 'north_data/employees_data.csv'
orders_path = 'north_data/orders_data.csv'


def write_table(path: str, table_name: str, cursor: 'psycopg2.connect().cursor()') -> None:
    """
    Функция для записи данных в таблицы базы данных

    :param path: Путь к файлу с данными
    :param table_name: Название таблицы
    :param cursor: Экземпляр класса cursor для работы с базами данных
    """

    with open(path) as file:
        reader = csv.DictReader(file)

        # Создание шаблона для команды записи строки в таблицу
        len_pattern = len(reader.fieldnames)
        sample_list = []
        for i in range(len_pattern):
            sample_list.append('%s')
        sample = ', '.join(sample_list)

        # Запись данных по шаблону
        for row in reader:
            values = row.values()

            cursor.execute(f'INSERT INTO {table_name} VALUES ({sample})',
                           tuple(values))


def main():
    """
    Основная функция работы программы
    """
    conn = psycopg2.connect(database='north', user='postgres', password=PASSWORD)
    try:
        with conn:
            with conn.cursor() as cur:
                write_table(customers_path, 'customers', cur)
                write_table(employees_path, 'employees', cur)
                write_table(orders_path, 'orders', cur)

    finally:
        conn.close()


if __name__ == '__main__':
    main()
