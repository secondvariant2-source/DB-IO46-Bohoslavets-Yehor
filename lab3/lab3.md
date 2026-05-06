# Лабораторна робота №3

## Маніпулювання даними SQL (OLTP)

---

### Роботу виконав

Студент групи ІО-46
Богославець Є.В.

### Роботу перевірив

Русінов В.В.

---

## Мета роботи

Ознайомитися з операціями маніпулювання даними в PostgreSQL та набути практичних навичок використання SQL-запитів типу SELECT, INSERT, UPDATE і DELETE для роботи з базою даних у режимі OLTP.

---

## Цілі

* Написати запити SELECT для отримання даних (включаючи фільтрацію за допомогою WHERE та вибір певних стовпців).
* Практикувати використання операторів INSERT для додавання нових рядків до таблиць.
* Практикувати використання оператора UPDATE для зміни існуючих рядків (використовуючи SET та WHERE).
* Практикувати використання операторів DELETE для безпечного видалення рядків (за допомогою WHERE).
* Вивчити основні операції маніпулювання даними (DML) у PostgreSQL та спостерігати за їхнім впливом.

---

## Хід роботи

### 1. Отримання даних (SELECT)

Було виконано запити для отримання даних з таблиць бази даних.

```sql
--Вибір тільки назви книг та автори
SELECT title, author FROM Book;
```
<img width="513" height="341" alt="image" src="https://github.com/user-attachments/assets/2bc2f0fe-4261-485c-83ed-a1bb2ff3e61d" />

```sql
-- Фільтрація книг, виданих після 1950 року
SELECT * FROM Book WHERE pub_year > 1950;
```
<img width="1069" height="198" alt="image" src="https://github.com/user-attachments/assets/4ef89f6c-033c-49fd-b5fd-7ba9ba6ce088" />

```sql
--Пошук читача за номером телефону
SELECT first_name, last_name FROM Reader WHERE phone = '+380991112233';
```
<img width="830" height="199" alt="image" src="https://github.com/user-attachments/assets/15961613-b8c9-42f4-9657-d02d4b5b4a6e" />


### 2. Додавання даних (INSERT)

Було додано нові записи до таблиць бази даних за допомогою оператора INSERT.

```sql
-- INSERT
-- Додавання нової книги
INSERT INTO Book (title, author, category, pub_year) 
VALUES ('Захар Беркут', 'Іван Франко', 'Історична повість', 1883);
```
<img width="731" height="77" alt="image" src="https://github.com/user-attachments/assets/e64010a1-1776-4567-b691-a5ee82b895d8" />
<img width="1064" height="243" alt="image" src="https://github.com/user-attachments/assets/ed069788-fc9a-4cee-8417-ce1c844a5247" />


```sql
INSERT INTO Exemplar (book_id, status, location) 
VALUES (6, 'доступна', 'Секція Г3');
```
<img width="744" height="183" alt="image" src="https://github.com/user-attachments/assets/39d2e81d-bd65-42a1-8d99-ab0f12979561" />

<img width="645" height="284" alt="image" src="https://github.com/user-attachments/assets/2c88ca6c-258c-46c6-b433-6e4691333450" />


### 3. Оновлення даних (UPDATE)

Було виконано оновлення існуючих записів у таблицях бази даних за допомогою оператора UPDATE із використанням умов WHERE.

```sql
-- Оновлюємо номер телефону читача (Артема)
UPDATE Reader 
SET phone = '+380445556677' 
WHERE last_name = 'Хімко';

-- Змінюємо статус примірника, коли книгу повернули
UPDATE Exemplar 
SET status = 'доступна' 
WHERE inv_number = 2;
```
<img width="585" height="234" alt="image" src="https://github.com/user-attachments/assets/81983339-f37a-4eba-8de1-39687fe59af2" />
<img width="640" height="243" alt="image" src="https://github.com/user-attachments/assets/d42a952c-860c-4b2f-be29-275f1d2b390e" />
<img width="1004" height="177" alt="image" src="https://github.com/user-attachments/assets/bbbb2520-5573-474e-9ef1-9fbdb36432d7" />




### 4. Видалення даних (DELETE)

Було виконано видалення записів із таблиць бази даних за допомогою оператора DELETE із використанням умов WHERE.

```sql

-- Видаляємо запис про видачу, якщо вона була закрита
DELETE FROM Loan 
WHERE loan_id = 1;
```
<img width="338" height="56" alt="image" src="https://github.com/user-attachments/assets/0b1fe444-52f2-4dbd-8a63-a1d8d1203b7d" />
<img width="706" height="119" alt="image" src="https://github.com/user-attachments/assets/0988f043-f16e-4d8f-b05b-762581f9dece" />

## Результати

У ході виконання лабораторної роботи було виконано SQL-запити для отримання, додавання, оновлення та видалення даних. Було перевірено коректність виконання кожної операції за допомогою SELECT-запитів. Отримані результати підтверджують правильність роботи з базою даних.

---

## Висновок

У ході виконання лабораторної роботи ми навчились працювати з операторами маніпулювання даними в PostgreSQL. Ми виконали запити SELECT, INSERT, UPDATE та DELETE, а також перевірили їхню роботу на практиці. У результаті ми зрозуміли принципи роботи OLTP-запитів та навчились безпечно змінювати дані в таблицях.
