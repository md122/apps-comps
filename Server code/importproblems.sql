DROP TABLE problems;
CREATE TABLE problems
(problem_num int,  level_num int, problem_text text, problem_type varchar(15),
  equation varchar(40), correct_answer varchar(40));

\copy problems FROM '/Users/appscomps/Desktop/AppsComps/problems.csv' DELIMITER ',' CSV HEADER
