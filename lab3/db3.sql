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

