CREATE TYPE sexes AS ENUM ('M', 'F');

CREATE TABLE classes (
id serial PRIMARY KEY,
class text UNIQUE NOT NULL,
num_students integer NOT NULL);

CREATE TABLE students (
id serial PRIMARY KEY,
name text NOT NULL,
student_number integer NOT NULL,
sex sexes NOT NULL,
enemy integer ARRAY,
class_id integer REFERENCES classes(id)
);