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

* Книжковий фонд (таблиця Book)
* Фізичні примірники книг (таблиця Exemplar)
* Зареєстрованих читачів (таблиця Reader)
* Співробітників бібліотеки (таблиця Staff)
* Журнал видачі та повернення книг (таблиця Loan)

---

## Реляційна схема бази даних

* Book(book_id, title, author, category, publisher, pub_year)
* Exemplar(inv_number, book_id, status, location)
* Reader(reader_id, first_name, last_name, phone, address)
* Staff(staff_id, full_name, position)
* Loan(loan_id, inv_number, reader_id, staff_id, issue_date, return_date)

---

## Опис таблиць

### 1. book
Містить загальну інформацію про видання.
**Поля:**
* book_id — первинний ключ
* title — назва
* author — автор
* category — жанр/категорія
* pub_year — рік видання

### 2. exemplar
Інформація про конкретні копії книг.
**Поля:**
* inv_number — інвентарний номер (PK)
* book_id — посилання на книгу (FK)
* status — стан (available, borrowed, damaged, lost)
* location — місце зберігання на стелажі
### 3. reader
Дані про користувачів бібліотеки.
**Поля:**
* reader_id — первинний ключ
* first_name, last_name — ім'я та прізвище
* phone — унікальний номер телефону

### 4. staff & loan
Таблиці для обліку персоналу та реєстрації фактів видачі книг.

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
    status VARCHAR(50) DEFAULT 'доступна' 
        CHECK (status IN ('доступна', 'видана', 'пошкоджена', 'втрачена')),
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
('Intermezzo', 'Михайло Коцюбинський', 'Новела', 1908),
('Кайдашева сім''я', 'Іван Нечуй-Левицький', 'Повість', 1878),
('Тигролови', 'Іван Багряний', 'Пригодницький роман', 1944),
('Маруся Чурай', 'Ліна Костенко', 'Історичний роман у віршах', 1979);

INSERT INTO Reader (first_name, last_name, phone, address) VALUES
('Артем', 'Хімко', '+380991112233', 'м. Київ, вул. Політехнічна, 16'),
('Олександр', 'Коваленко', '+380954445566', 'м. Київ, пр-т Перемоги, 45'),
('Марія', 'Петренко', '+380937778899', 'м. Київ, вул. Борщагівська, 126'),
('Дмитро', 'Шевченко', '+380670001122', 'м. Бровари, вул. Незалежності, 10');

INSERT INTO Staff (full_name, position) VALUES
('Олена Бондаренко', 'Старший бібліотекар'),
('Ігор Ткаченко', 'Адміністратор бази'),
('Анна Сидоренко', 'Молодший бібліотекар');

INSERT INTO Exemplar (book_id, status, location) VALUES
(1, 'доступна', 'Секція А1'),
(1, 'видана', 'Секція А1'),
(2, 'доступна', 'Секція Б2'),
(3, 'доступна', 'Секція Б2'),
(4, 'доступна', 'Секція В1'),
(5, 'пошкоджена', 'Відділ реставрації');

INSERT INTO Loan (reader_id, inv_number, staff_id, issue_date, return_date) VALUES
(1, 2, 1, '2026-05-01', '2026-05-15'),
(2, 4, 3, '2026-05-04', NULL), 
(3, 1, 1, '2026-04-20', '2026-05-04');

SELECT * FROM Book;
```
#Тестування
##1. Перевірка створення таблиць
<img width="223" height="178" alt="image" src="https://github.com/user-attachments/assets/79978995-41ca-4b04-b7a8-ef0e8de550e6" />

##2. Наповнення таблиць тестовими даними
У кожну таблицю було додано тестові записи (не менше 3 записів).
<img width="1064" height="209" alt="image" src="https://github.com/user-attachments/assets/f5ddcf5a-4e60-463b-bfc7-377e03ae6222" />

##3. Перевірка SELECT-запитів
Було виконано ряд SQL-запитів для перевірки цілісності та зв’язків між таблицями:

<img width="1096" height="304" alt="image" src="https://github.com/user-attachments/assets/36012d13-f7ea-4f65-b2e5-936b0b4eda25" />
<img width="718" height="321" alt="image" src="https://github.com/user-attachments/assets/fb51184d-2681-48c0-b45e-d37834eaeb7d" />
Усі SQL-запити виконуються без помилок.
База даних працює коректно, зв’язки між таблицями реалізовані правильно.

#Результати
У результаті виконання роботи:

*створено реляційну схему бази даних
*реалізовано всі сутності ER-діаграми
*встановлено первинні та зовнішні ключі
*додано обмеження (UNIQUE, NOT NULL, CHECK, DEFAULT)
*виконано заповнення таблиць тестовими даними
*перевірено коректність роботи у pgAdmin

#Висновок
У ході лабораторної роботи було успішно перетворено ER-діаграму бібліотеки на реляційну модель PostgreSQL. Створено таблиці з відповідними типами даних та обмеженнями цілісності. База даних наповнена тестовими даними українською мовою та готова до виконання запитів.
INSERT INTO Loan (reader_id, inv_number, staff_id, issue_date) VALUES
(1, 1, 1, '2026-05-06');
