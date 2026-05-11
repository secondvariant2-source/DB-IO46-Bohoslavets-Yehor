# Лабораторна робота №6
## Тема: Міграції схем за допомогою Prisma ORM

---

### Роботу виконував
Студент групи ІО-46
**Богославець Є.В.**

---

## 1. Мета роботи
* Ініціалізація Prisma ORM у проекті та підключення до існуючої бази даних PostgreSQL.
* Вивчення процесу реверс-інжинірингу схеми (db pull).
* Практика управління змінами схеми за допомогою механізму міграцій (Prisma Migrate).
* Перевірка цілісності даних та працездатності схеми через Prisma Studio.

---

## 2. Початкове налаштування та Introspection

1.  **Ініціалізація проекту**: Встановлено пакети `prisma` та `@prisma/client`.
2.  **Підключення**: У файлі `.env` налаштовано `DATABASE_URL` для підключення до Docker-контейнера з БД.
3.  **Зчитування схеми**: Виконано команду `npx prisma db pull`, яка проаналізувала базу даних з ЛР №5 та автоматично згенерувала моделі у файлі `schema.prisma`.
<img width="1233" height="392" alt="image" src="https://github.com/user-attachments/assets/5efa5f22-d4e7-412b-bc97-f0cbd18f7595" />

---

## 3. Процес міграцій та зміни схеми

Відповідно до завдання, було проведено три послідовні зміни в схемі даних.

### Міграція 1: Додавання таблиці відгуків
**Опис**: Створено нову модель `Review` для зберігання оцінок та коментарів читачів до книг.
* **Код у schema.prisma**:
```prisma
generator client {
  provider = "prisma-client"
  output   = "../generated/prisma"
}

datasource db {
  provider = "postgresql"
}


model Book {
  id        Int      @id @default(autoincrement())
  title     String
  author    String
  pub_year  Int
  exemplars Exemplar[]
}

model Exemplar {
  inv_number Int    @id @default(autoincrement())
  status     String
  location   String
  book_id    Int
  book       Book   @relation(fields: [book_id], references: [id])
  loans      Loan[]
}

model Reader {
  id         Int    @id @default(autoincrement())
  first_name String
  last_name  String
  phone      String @unique
  address    String?
  loans      Loan[]
}

model Staff {
  id        Int    @id @default(autoincrement())
  full_name String
  loans     Loan[]
}

model Loan {
  id          Int      @id @default(autoincrement())
  issue_date  DateTime @default(now())
  return_date DateTime?
  reader_id   Int
  staff_id    Int
  inv_number  Int
  reader      Reader   @relation(fields: [reader_id], references: [id])
  staff       Staff    @relation(fields: [staff_id], references: [id])
  exemplar    Exemplar @relation(fields: [inv_number], references: [inv_number])

model Review {
  id        Int      @id @default(autoincrement())
  rating    Int
  comment   String?
  bookId    Int
  book      Book     @relation(fields: [bookId], references: [book_id])
}
```
<img width="761" height="203" alt="image" src="https://github.com/user-attachments/assets/36ba2792-9583-43cb-bdf5-bf94d7683411" />

<img width="778" height="676" alt="image" src="https://github.com/user-attachments/assets/2d90b1ec-3bc9-4299-adad-58ee033f2671" />
## Висновок
 Під час виконання лабораторної роботи було опановано інструментарій Prisma ORM для керування схемою бази даних. Використання міграцій замість прямого написання SQL-запитів дозволяє безпечно та послідовно змінювати структуру БД, зберігаючи історію змін у системі контролю версій. Всі поставлені завдання виконані, працездатність оновленої схеми підтверджена.
