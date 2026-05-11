# Лабораторна робота №4

## Аналітичні SQL-запити (OLAP)
---

### Роботу виконали

Студент групи ІО-46
Богославець Є.В.

### Роботу перевірив

Русінов В.В.

---

## Мета роботи

Ознайомлення з аналітичними SQL-запитами (OLAP), використання агрегатних функцій, групування даних, об'єднання таблиць (JOIN) та підзапитів для отримання узагальненої інформації з бази даних.

---

## Цілі

* Використовувати агрегатні функції, такі як COUNT, SUM, AVG, MIN та MAX, для обчислення зведеної статистики з ваших даних.
* Написати запити GROUP BY для групування рядків за одним або кількома стовпцями та обчислення агрегатів для кожної групи.
* Використовувати HAVING для фільтрації результатів згрупованих запитів на основі агрегованих умов.
* Виконувати операції JOIN (принаймні INNER JOIN та LEFT JOIN), щоб об'єднати дані з кількох таблиць.
* Створювати об'єднані запити на агрегацію для кількох таблиць, які об'єднують таблиці та створюють згрупований, агрегований вивід.
* Інтерпретувати результати ваших запитів та пояснити, що робить кожен з них.

---

## Хід роботи

### 1. Запити з агрегатними функціями 

```sql
-- Загальна кількість книг та найстаріший рік видання
SELECT 
    COUNT(*) AS total_books, 
    MIN(pub_year) AS oldest_book_year 
FROM Book;
```
<img width="786" height="299" alt="image" src="https://github.com/user-attachments/assets/b38a3dc8-54aa-46b1-8805-ffba9bc1da9e" />




--- 

```sql
--Кількість книг у кожній категорії
SELECT category, COUNT(*) AS count_in_category
FROM Book
GROUP BY category;
```
<img width="768" height="391" alt="image" src="https://github.com/user-attachments/assets/08713a70-cb09-4e03-a90e-146733227f4a" />


--- 

```sql
--Читачі, які мають більше 1 активної видачі
SELECT reader_id, COUNT(*) AS active_loans
FROM Loan
GROUP BY reader_id
HAVING COUNT(*) > 1;

```
<img width="770" height="471" alt="image" src="https://github.com/user-attachments/assets/0551fa01-b867-4aba-8c38-cd2801ba4cf8" />

--- 

```sql
--Середній рік видання книг по кожному автору
SELECT author, ROUND(AVG(pub_year)) AS avg_pub_year
FROM Book
GROUP BY author;
```
<img width="779" height="392" alt="image" src="https://github.com/user-attachments/assets/61eb2282-c73e-431c-a8c2-37b01cbc147e" />

---

### 2. Запити з операціями JOIN, щоб об'єднати дані з кількох таблиць:

```sql
--INNER JOIN: Список виданих книг з іменами читачів та бібліотекарів
SELECT r.last_name, b.title, s.full_name AS librarian
FROM Loan l
INNER JOIN Reader r ON l.reader_id = r.reader_id
INNER JOIN Exemplar e ON l.inv_number = e.inv_number
INNER JOIN Book b ON e.book_id = b.book_id
INNER JOIN Staff s ON l.staff_id = s.staff_id;
```
<img width="834" height="435" alt="image" src="https://github.com/user-attachments/assets/3ed0d517-3c3a-4916-ad20-3290629c0ecf" />




---

```sql
--LEFT JOIN: Всі книги та інформація про їхні видачі (включаючи ті, що ніколи не видавалися)
SELECT b.title, l.issue_date
FROM Book b
LEFT JOIN Exemplar e ON b.book_id = e.book_id
LEFT JOIN Loan l ON e.inv_number = l.inv_number;
```
<img width="1056" height="394" alt="image" src="https://github.com/user-attachments/assets/c0ee0158-ed16-4cfc-82b0-3cc8689d1cc1" />

---

```sql
--FULL JOIN: Співставлення всіх читачів та всіх операцій видачі
SELECT r.last_name, l.loan_id
FROM Reader r
```
<img width="763" height="359" alt="image" src="https://github.com/user-attachments/assets/b7da7478-f7db-4e95-ab11-fafa6d35cd20" />


---

### 3. Запити з використанням підзапитів (вибірка з підзапитом у SELECT, WHERE, або HAVING):

```sql
--Підзапит у WHERE: Знайти книги того ж автора, що й книга з ID=1
SELECT title FROM Book 
WHERE author = (SELECT author FROM Book WHERE book_id = 1);
```
<img width="774" height="310" alt="image" src="https://github.com/user-attachments/assets/2f27cfd7-497c-4485-8f70-5bb01a763f80" />


---

```sql
--Підзапит у SELECT: Вивести назву книги поруч із кожним інвентарним номером
SELECT inv_number, 
       (SELECT title FROM Book WHERE Book.book_id = Exemplar.book_id) AS book_title
FROM Exemplar;
```
<img width="959" height="468" alt="image" src="https://github.com/user-attachments/assets/813fb070-f9c0-49c3-a3ec-ae14d51c5eda" />


---

```sql
--Підзапит у HAVING: Категорії, де кількість книг вища за середню кількість книг по категоріях
SELECT category, COUNT(*) 
FROM Book 
GROUP BY category
HAVING COUNT(*) > (SELECT COUNT(*)/COUNT(DISTINCT category) FROM Book);
```
<img width="1061" height="355" alt="image" src="https://github.com/user-attachments/assets/5bfd8deb-ab0e-4e2f-88e4-1fb6551ca6ab" />

---

## Висновок

У ході виконання лабораторної роботи було використано агрегатні функції для обчислення статистичних показників, реалізовано групування даних за допомогою GROUP BY, застосовано різні типи JOIN для об'єднання таблиць. 
Крім того, були використані підзапити для отримання більш складних аналітичних результатів. Отримані результати підтверджують ефективність використання SQL для аналізу даних.
