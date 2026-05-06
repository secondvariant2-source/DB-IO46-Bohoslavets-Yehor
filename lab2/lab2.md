# Лабораторна робота №2

## Перетворення ER-діаграми на схему PostgreSQL

---

### Роботу виконав

Студент групи ІО-46
Богославець Єгор

### Роботу перевірив

Русінов В. В.

## Мета роботи

Перетворити ER-діаграму предметної області на реляційну схему PostgreSQL, створити таблиці з відповідними типами даних, ключами та обмеженнями, а також заповнити їх тестовими даними.

---

## Опис

У даній роботі реалізовано базу даних для автоматизації бібліотеки, яка дозволяє зберігати інформацію про:

* Книжковий фонд (таблиця Book)[cite: 1]
* Фізичні примірники книг (таблиця Exemplar)[cite: 1]
* Зареєстрованих читачів (таблиця Reader)[cite: 1]
* Співробітників бібліотеки (таблиця Staff)[cite: 1]
* Журнал видачі та повернення книг (таблиця Loan)[cite: 1]

---

## Реляційна схема бази даних

* Book(book_id, title, author, category, publisher, pub_year)[cite: 1]
* Exemplar(inv_number, book_id, status, location)[cite: 1]
* Reader(reader_id, first_name, last_name, phone, address)[cite: 1]
* Staff(staff_id, full_name, position)[cite: 1]
* Loan(loan_id, inv_number, reader_id, staff_id, issue_date, return_date)[cite: 1]

---

## Опис таблиць

### 1. book
Містить загальну інформацію про видання[cite: 1].
**Поля:**
* book_id — первинний ключ[cite: 1]
* title — назва[cite: 1]
* author — автор[cite: 1]
* category — жанр/категорія[cite: 1]
* pub_year — рік видання[cite: 1]

### 2. exemplar
Інформація про конкретні копії книг[cite: 1].
**Поля:**
* inv_number — інвентарний номер (PK)[cite: 1]
* book_id — посилання на книгу (FK)[cite: 1]
* status — стан (available, borrowed, damaged, lost)[cite: 1]
* location — місце зберігання на стелажі[cite: 1]

### 3. reader
Дані про користувачів бібліотеки[cite: 1].
**Поля:**
* reader_id — первинний ключ[cite: 1]
* first_name, last_name — ім'я та прізвище[cite: 1]
* phone — унікальний номер телефону[cite: 1]

### 4. staff & loan
Таблиці для обліку персоналу та реєстрації фактів видачі книг[cite: 1].

---

## SQL-реалізація
```sql
CREATE TABLE IF NOT EXISTS Book (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    publisher VARCHAR(100),
    pub_year INTEGER CHECK (pub_year > 0 AND pub_year <= 2026)
);

CREATE TABLE IF NOT EXISTS Exemplar (
    inv_number SERIAL PRIMARY KEY,
    book_id INTEGER NOT NULL REFERENCES Book(book_id) ON DELETE CASCADE,
    status VARCHAR(50) DEFAULT 'available' CHECK (status IN ('available', 'borrowed', 'damaged', 'lost')),
    location VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Reader (
    reader_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    address TEXT
);

CREATE TABLE IF NOT EXISTS Staff (
    staff_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    position VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Loan (
    loan_id SERIAL PRIMARY KEY,
    inv_number INTEGER NOT NULL REFERENCES Exemplar(inv_number),
    reader_id INTEGER NOT NULL REFERENCES Reader(reader_id),
    staff_id INTEGER NOT NULL REFERENCES Staff(staff_id),
    issue_date DATE NOT NULL DEFAULT CURRENT_DATE,
    return_date DATE CHECK (return_date >= issue_date)
);

TRUNCATE Book, Reader, Staff, Exemplar, Loan RESTART IDENTITY CASCADE;

INSERT INTO Book (title, author, category, pub_year) VALUES
('Тіні забутих предків', 'Михайло Коцюбинський', 'Повість', 1911),
('Кайдашева сім''я', 'Іван Нечуй-Левицький', 'Повість', 1878),
('Тигролови', 'Іван Багряний', 'Пригодницький роман', 1944);

INSERT INTO Reader (first_name, last_name, phone, address) VALUES
('Артем', 'Хімко', '+380991112233', 'м. Київ, вул. Політехнічна, 16');

INSERT INTO Staff (full_name, position) VALUES
('Олена Бондаренко', 'Старший бібліотекар');

INSERT INTO Exemplar (book_id, status, location) VALUES
(1, 'available', 'Секція А1'), (2, 'borrowed', 'Секція А1');

INSERT INTO Loan (reader_id, inv_number, staff_id, issue_date) VALUES
(1, 1, 1, '2026-05-06');
