# Kateryna Yeromenko CS31
Hospital app

## HTTP Verbs
| HTTP METHOD | URL                    | Payload                                         | Description                                            |
|-------------|------------------------|-------------------------------------------------|--------------------------------------------------------|
| GET         | /hospitals             | {}                                              | Shows all hospitals                                    |
| GET         | /hospitals/:id         | {id: 77}                                        | Shows hospital with specific id                        |
| POST        | /hospitals/new         | {name: 'Clnc1', email: 'aaa@aaa.com',           | Creates a new hospital with the payload                |
|             |                        | phone: 3801234567, address: '7 S St'}           |                                                        |
| PUT/PATCH   | /hospitals/:id/edit    | {name: 'Clnc2', email: 'bbb@bbb.com',           | Updates hospital with specific id with the payload     |
|             |                        | phone: 3802345678, address: '8 S St'}           |                                                        |
| DELETE      | /hospitals/:id         | {id: 77}                                        | Deletes hospital with the given id                     |
| GET         | /departments           | {}                                              | Shows all departments                                  |
| GET         | /departments/:id       | {id: 77}                                        | Shows department with specific id                      |
| POST        | /departments/new       | {name: 'Dprt1', description: '...'}             | Creates a new department with the payload              |
| PUT/PATCH   | /departments/:id/edit  | {name: 'Dprt2', description: '!!!'}             | Updates department with specific id with the payload   |
| DELETE      | /departments/:id       | {id: 77}                                        | Deletes department with the given id                   |
| GET         | /specialties           | {}                                              | Shows all specialties                                  |
| GET         | /specialties/:id       | {id: 77}                                        | Shows specialty with specific id                       |
| POST        | /specialties/new       | {name: 'Sclt1', description: '...'}             | Creates a new specialty with the payload               |
| PUT/PATCH   | /specialties/:id/edit  | {name: 'Sclt2', description: '!!!'}             | Updates specialty with specific id with the payload    |
| DELETE      | /specialties/:id       | {id: 77}                                        | Deletes specialty with the given id                    |
| GET         | /doctors               | {}                                              | Shows all doctors                                      |
| GET         | /doctors/:id           | {id: 77}                                        | Shows doctor with specific id                          |
| POST        | /doctors/new           | {name: 'Dctr1', email: 'ccc@ccc.com',           | Creates a new doctor with the payload                  |
|             |                        | phone: 3803456789}                              |                                                        |
| PUT/PATCH   | /doctors/:id/edit      | {name: 'Dctr2', email: 'ddd@ddd.com'            | Updates doctor with specific id with the payload       |
|             |                        | phone: 3804567890}                              |                                                        |
| DELETE      | /doctors/:id           | {id: 77}                                        | Deletes doctor with the given id                       |
| GET         | /patients              | {}                                              | Shows all patients                                     |
| GET         | /patients/:id          | {id: 77}                                        | Shows patient with specific id                         |
| POST        | /patients/new          | {name: 'Ptnt1', birthdate: '2005-05-05',        | Creates a new patient with the payload                 |
|             |                        | phone: 3805678901, address: '9 S St'}           |                                                        |
| PUT/PATCH   | /patients/:id/edit     | {name: 'Ptnt2', birthdate: '2010-10-10',        | Updates patient with specific id with the payload      |
|             |                        | phone: 3806789012, address: '1 S St'}           |                                                        |
| DELETE      | /patients/:id          | {id: 77}                                        | Deletes patient with the given id                      |
| GET         | /patientcards          | {}                                              | Shows all patient cards                                |
| GET         | /patientcards/:id      | {id: 77}                                        | Shows patient card with specific id                    |
| POST        | /patientcards/new      | {code: 'GH2468', description: '!?!'}            | Creates a new patient card with the payload            |
| PUT/PATCH   | /patientcards/:id/edit | {code: 'HG8642', description: '?!?'}            | Updates patient card with specific id with the payload |
| DELETE      | /patientcards/:id      | {id: 77}                                        | Deletes patient card with the given id                 |

## ERD diagram
 +-----------+       +------------------+       +-----------+       +------------------+       +--------------------+       +----------------+
 | Patients  |  1:1  | PatientCards     |  N:1  | Hospitals |  1:N  | Departments      |  1:N  | Doctors            |  N:1  | Specialties    |
 +-----------+<----->+------------------+------>+-----------+<------+------------------+<------+--------------------+------>+----------------+
 | id (PK)   |       | id (PK)          |       | id (PK)   |       | id (PK)          |       | id (PK)            |       | id (PK)        |
 | name      |       | code             |       | name      |       | name             |       | name               |       | name           |
 | birthdate |       | description      |       | email     |       | description      |       | email              |       | description    |
 | phone     |       | hospital_id (FK) |       | phone     |       | hospital_id (FK) |       | phone              |       +----------------+
 | address   |       | patient_id (FK)  |       | address   |       +------------------+       | department_id (FK) |
 +-----------+       +------------------+       +-----------+                                  | specialty_id (FK)  |
                                                                                               +--------------------+

### Labs
- [] Task 1 -> Створити моделі, що відповідають таким таблицям у базі даних додатку:
Клініки (поля на вибір)
Відділення (поля на вибір. Клініка може мати n відділень)
Лікарі (поля на вибір. Відділення може мати n лікарів)
Спеціальності (поля на вибір. Лікар належить до 1 спеціальністі)
Карти пацієнтів (поля на вибір У клініці може бути багато карток)
Пацієнти (поля на вибір У карті може бути 1 пацієнт)
- [] Task 2 --> Вставити 100 записів у таблиці. У 3 таблиці зробити методи, які будуть обгорткою на чистому SQL. У 3 інші таблиці просто на ОРМ. Зробити по 2 SQL VIEW.
- [] Task 3 --> Написати Readme.md файл. Зробити CRUD форми під кожну модель.