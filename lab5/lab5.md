# Лабораторна робота №5
## Нормалізація бази даних
---
### Роботу виконали
Студент групи ІО-46
Богославець Є. В.
### Роботу перевірив
Русінов В.В.
---
## Мета роботи
* Пошук надлишковості та аномалій: виявлення потенційної надлишковості даних (наприклад, повторювані значення) або аномалій оновлення (проблеми вставки/оновлення/видалення) у поточній схемі.
* Перелік функціональних залежностей: визначте та перелічіть функціональні залежності (ФЗ) для кожної проблемної таблиці.
* Перевірка нормальних форм: оцініть поточну нормальну форму кожної таблиці (1NF, 2NF, 3NF) на основі її функціональних залежностей (ФЗ) та структури ключа.
* Застосування нормалізації: перетворення таблиць у вищі нормальні форми (до 3НФ) для усунення часткових та транзитивних залежностей.
---
## Хід роботи
### Пошук надлишковості та аномалій
<img width="1191" height="491" alt="lab1 drawio" src="https://github.com/user-attachments/assets/88e45e99-f049-4da7-958a-845f3efab9f4" />
Рисунок 1 – Початкова ER-діаграма бази даних бібліотеки
Під час аналізу початкової схеми (ЛР №1) було виявлено такі проблеми:

1.  **Таблиця `Book`**: Жанр книги зберігався у текстовому полі `category`. Це створює надлишковість (назва "Фантастика" дублюється сотні разів) та **аномалію оновлення** (якщо змінити назву жанру, треба редагувати багато рядків).
2.  **Таблиця `Staff`**: Поле `position` (посада) також зберігалося як текст. Це створює ризик друкарських помилок та **аномалій вставки** (можна випадково додати неіснуючу посаду).

---

## Перелік функціональних залежностей (ФЗ)

Для основних таблиць визначено такі залежності:

* **Book**: `book_id` → `title`, `author`, `category`, `publisher`, `pub_year`.
* **Reader**: `reader_id` → `first_name`, `last_name`, `phone`, `address`.
* **Staff**: `staff_id` → `full_name`, `position`.
* **Exemplar**: `inv_number` → `book_id`, `status`, `location`.
* **Loan**: `loan_id` → `inv_number`, `reader_id`, `staff_id`, `issue_date`, `return_date`.

---

## Перевірка нормальних форм

* **1NF (Перша нормальна форма)**: Схема відповідає 1NF. Усі значення в стовпцях атомарні, повторювані групи (масиви) відсутні.
* **2NF (Друга нормальна форма)**: Схема відповідає 2NF. Усі таблиці мають прості первинні ключі (складаються з одного поля). Отже, будь-яка часткова залежність від ключа неможлива.
* **3NF (Третя нормальна форма)**: **Порушується.** * У таблиці `Book` існує транзитивна залежність: `book_id` → `category` (категорія є незалежною назвою, яка має бути винесена в довідник).
    * У таблиці `Staff` аналогічно: `staff_id` → `position`.

---

## Застосування нормалізації (Декомпозиція до 3NF)

Щоб привести базу до 3NF, проведено декомпозицію:

### Нормалізація таблиці Book:
* Створено таблицю-довідник **`Category`**: `(PK) category_id`, `category_name`.
* У таблиці `Book` видалено текстове поле `category` та додано **`(FK) category_id`**.

### Нормалізація таблиці Staff:
* Створено таблицю-довідник **`Position`**: `(PK) position_id`, `title`.
* У таблиці `Staff` видалено текстове поле `position` та додано **`(FK) position_id`**.
### Перероблені SQL-інструкції CREATE TABLE
Нижче наведено команди для трансформації поточної бази даних бібліотеки в 3NF.
```sql
-- 1. Нормалізація категорій
CREATE TABLE Category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO Category (category_name) SELECT DISTINCT category FROM Book;

ALTER TABLE Book ADD COLUMN category_id INT;
UPDATE Book b SET category_id = c.category_id FROM Category c WHERE b.category = c.category_name;
ALTER TABLE Book DROP COLUMN category;
ALTER TABLE Book ADD CONSTRAINT fk_book_category FOREIGN KEY (category_id) REFERENCES Category(category_id);

-- 2. Нормалізація посад
CREATE TABLE Position (
    position_id SERIAL PRIMARY KEY,
    title VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO Position (title) SELECT DISTINCT position FROM Staff;

ALTER TABLE Staff ADD COLUMN position_id INT;
UPDATE Staff s SET position_id = p.position_id FROM Position p WHERE s.position = p.title;
ALTER TABLE Staff DROP COLUMN position;
ALTER TABLE Staff ADD CONSTRAINT fk_staff_position FOREIGN KEY (position_id) REFERENCES Position(position_id);
```
### ERD після нормалізації
<img width="1191" height="566" alt="lab5 drawio" src="https://github.com/user-attachments/assets/b82910cb-cf66-4977-b82a-8cd94d6a94f1" />

Рисунок 2 – Оновлена нормалізована схема даних моргу
---
## Висновки
У ході лабораторної роботи було проведено повний аналіз схеми бази даних бібліотеки. Шляхом виявлення транзитивних функціональних залежностей було встановлено, що початкова схема відповідала лише 2NF. Завдяки декомпозиції таблиць staff та book на більш дрібні сутності, було досягнуто Третьої нормальної форми (3NF). Це мінімізує надлишковість даних та гарантує відсутність аномалій при оновленні інформації.
