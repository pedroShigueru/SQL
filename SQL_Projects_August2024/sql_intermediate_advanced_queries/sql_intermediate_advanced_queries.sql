use intermediate_advanced_queries;

CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) NOT NULL
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    date_of_join DATE NOT NULL,
    dept_id INT,
    city VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE
);

CREATE TABLE employee_projects (
    emp_id INT,
    project_id INT,
    hours_worked DECIMAL(5, 2) NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    PRIMARY KEY (emp_id, project_id)
);

INSERT INTO departments (dept_name) VALUES
('Engineering'),
('Marketing'),
('HR'),
('Finance');

INSERT INTO employees (emp_name, age, gender, date_of_join, dept_id, city, salary) VALUES
('Alice Johnson', 29, 'Female', '2019-03-15', 1, 'New York', 85000.00),
('Bob Smith', 35, 'Male', '2018-06-22', 2, 'Los Angeles', 95000.00),
('Charlie Lee', 28, 'Male', '2020-01-10', 3, 'Chicago', 60000.00),
('Dana White', 32, 'Female', '2017-09-05', 4, 'Houston', 78000.00),
('Eve Davis', 45, 'Female', '2015-11-30', 1, 'San Francisco', 120000.00),
('Frank Brown', 41, 'Male', '2016-02-18', 1, 'New York', 110000.00),
('Grace Green', 26, 'Female', '2021-07-12', 2, 'Los Angeles', 62000.00),
('Hank Miller', 38, 'Male', '2017-04-25', 3, 'Chicago', 70000.00),
('Ivy Wilson', 30, 'Female', '2019-12-02', 4, 'Houston', 87000.00),
('Jack Taylor', 50, 'Male', '2013-05-18', 1, 'San Francisco', 135000.00);

-- Mudei a cidade, pois quando eu fazia select count(city) from employees group by city, 
-- a tabela me retornava dois valores de cada cidade, porem queria valores diferentes para 
-- ver se eu estava fazendo a query realmente certa

update employees
set city = 'Los Angeles'
where emp_id = 1;

INSERT INTO projects (project_name, start_date, end_date) VALUES
('Project Alpha', '2020-01-01', '2020-12-31'),
('Project Beta', '2020-06-01', NULL),
('Project Gamma', '2021-03-15', NULL),
('Project Delta', '2019-11-01', '2020-11-30');

INSERT INTO employee_projects (emp_id, project_id, hours_worked) VALUES
(1, 1, 150.50),
(2, 2, 200.00),
(3, 3, 120.75),
(4, 4, 300.25),
(5, 1, 180.00),
(6, 2, 220.50),
(7, 3, 95.00),
(8, 4, 250.75),
(9, 1, 140.00),
(10, 2, 190.00);

-- Primeira Questao: Listar todos os empregados com seus respectivos departamentos
select employees.emp_name, departments.dept_name from employees
left join departments on departments.dept_id = employees.dept_id;

select employees.emp_name, departments.dept_name from employees
where departments.dept_id = (select departments.dept_id from departments where departments.dept_id = employees.dept_id);

-- Segunda Questao: Encontrar a quantidade total de horas trabalhadas em cada projeto
select project_id, sum(hours_worked) as hours_worked from employee_projects
group by project_id;

-- Tericeira Questao: Listar empregados que trabalharam mais de 150 horas em qualquer projeto

select employees.emp_name, employee_projects.hours_worked from employees
left join employee_projects on employee_projects.emp_id = employees.emp_id
where employee_projects.emp_id in (select employee_projects.emp_id from employee_projects
group by employee_projects.emp_id having sum(employee_projects.hours_worked) > 150);

-- Quarta Questao: Encontrar a média salarial por departamento
select round(avg(salary), 2) as salary_avg, dept_id from employees
group by dept_id;

-- Quinta Questao: Listar os projetos ativos (sem data de termino) e os empregados que estão trabalhando neles
select * from projects;

select project_name, start_date from projects
where end_date is null;

-- Sexta Questao: Encontrar o empregado mais bem pago de cada departamento 

select employees.emp_name, employees.salary, departments.dept_name from employees
join departments on employees.dept_id = departments.dept_id
where employees.salary = (select max(salary) from employees where dept_id = departments.dept_id);

-- Setima Questao: Calcular a média de horas trabalhadas por empregado em cada projeto
select avg(employee_projects.hours_worked) as hours_worked_avg, projects.project_name from employee_projects
join projects on projects.project_id = employee_projects.project_id
group by projects.project_id, projects.project_name;

-- Oitava Questao: Listar empregados que não estão alocados em nenhum projeto
select * from employee_projects;

select emp_id, emp_name from employees
where emp_id in (select emp_id from employee_projects
				where project_id in (select project_id from projects
									 where end_date is not null));

-- Nona Questao: Encontrar todos os empregados e os projetos em que trabalham, mesmo que não estejam alocados a nenhum projeto
select employees.emp_name, projects.project_name from employees
join employee_projects on employee_projects.emp_id = employees.emp_id
join projects on employee_projects.project_id = projects.project_id;

-- Decima Questao: Listar o total de empregados em cada cidade, ordenado pela quantidade em ordem decrescente
select count(city) as num_employees, city from employees
group by city
order by count(city) desc;

