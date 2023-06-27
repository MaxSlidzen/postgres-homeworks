"""Скрипт для заполнения данными таблиц в БД Postgres."""
import psycopg2
import csv
import os

# Персональный пароль для работы с postgres
PASSWORD = os.getenv('psql_password')


def main():
    """
    Основная функция работы программы
    """
    # Открытие базы данных
    conn = psycopg2.connect(database='north', user='postgres', password=PASSWORD)

    try:
        with conn:
            # Создание экземпляра курсора для работы
            with conn.cursor() as cur:

                # Заполнение таблицы customers из csv файла
                with open('north_data/customers_data.csv', encoding='utf-8') as file:
                    reader = csv.DictReader(file)
                    for row in reader:
                        cur.execute('INSERT INTO customers VALUES (%s, %s, %s)',
                                    (row['customer_id'], row['company_name'], row['contact_name']))

                # Заполнение таблицы employees из csv файла
                with open('north_data/employees_data.csv', encoding='utf-8') as file:
                    reader = csv.DictReader(file)
                    for row in reader:
                        cur.execute('INSERT INTO employees VALUES (%s, %s, %s, %s, %s, %s)',
                                    (row['employee_id'], row['first_name'], row['last_name'],
                                     row['title'], row['birth_date'], row['notes']))

                # Заполнение таблицы orders из csv файла
                with open('north_data/orders_data.csv', encoding='utf-8') as file:
                    reader = csv.DictReader(file)
                    for row in reader:
                        cur.execute('INSERT INTO orders VALUES (%s, %s, %s, %s, %s)',
                                    (row['order_id'], row['customer_id'], row['employee_id'],
                                     row['order_date'], row['ship_city']))
    # Закрытие базы данных
    finally:
        conn.close()


if __name__ == '__main__':
    main()
