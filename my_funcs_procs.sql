-- Fonctions

CREATE OR REPLACE FUNCTION GET_NB_WORKERS(FACTORY_ID NUMBER) RETURN NUMBER IS
  total_workers NUMBER;
BEGIN
  SELECT COUNT(*) INTO total_workers FROM workers WHERE factory_id = FACTORY_ID;
  RETURN total_workers;
END GET_NB_WORKERS;
/

CREATE OR REPLACE FUNCTION GET_NB_BIG_ROBOTS RETURN NUMBER IS
  total_big_robots NUMBER;
BEGIN
  SELECT COUNT(*) INTO total_big_robots FROM robots WHERE nombre_de_pieces > 3;
  RETURN total_big_robots;
END GET_NB_BIG_ROBOTS;
/

CREATE OR REPLACE FUNCTION GET_BEST_SUPPLIER RETURN VARCHAR2 IS
  best_supplier_name VARCHAR2(100);
BEGIN
  SELECT supplier_name INTO best_supplier_name FROM suppliers WHERE pieces_delivered > 1000 ORDER BY pieces_delivered DESC FETCH FIRST 1 ROW ONLY;
  RETURN best_supplier_name;
END GET_BEST_SUPPLIER;
/

CREATE OR REPLACE FUNCTION GET_OLDEST_WORKER RETURN NUMBER IS
  oldest_worker_id NUMBER;
BEGIN
  SELECT worker_id INTO oldest_worker_id FROM workers ORDER BY start_date ASC FETCH FIRST 1 ROW ONLY;
  RETURN oldest_worker_id;
END GET_OLDEST_WORKER;
/

-- Procédures

CREATE OR REPLACE PROCEDURE SEED_DATA_WORKERS(NB_WORKERS NUMBER, FACTORY_ID NUMBER) IS
BEGIN
  FOR i IN 1..NB_WORKERS LOOP
    INSERT INTO workers (worker_id, factory_id, firstname, lastname, start_date)
    VALUES (worker_sequence.NEXTVAL, FACTORY_ID, 'worker_f_' || i, 'worker_l_' || i, 
    TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2065-01-01','J'), TO_CHAR(DATE '2070-01-01','J'))), 'J'));
  END LOOP;
END SEED_DATA_WORKERS;
/

CREATE OR REPLACE PROCEDURE ADD_NEW_ROBOT(MODEL_NAME VARCHAR2(50)) IS
BEGIN
  INSERT INTO robots (robot_id, model_name, factory_id)
  VALUES (robot_sequence.NEXTVAL, MODEL_NAME, (SELECT factory_id FROM robots_factories WHERE robot_id = robot_sequence.CURRVAL));
END ADD_NEW_ROBOT;
/

CREATE OR REPLACE PROCEDURE SEED_DATA_SPARE_PARTS(NB_SPARE_PARTS NUMBER) IS
BEGIN
  FOR i IN 1..NB_SPARE_PARTS LOOP
    INSERT INTO spare_parts (spare_part_id, part_name)
    VALUES (spare_part_sequence.NEXTVAL, 'spare_part_' || i);
  END LOOP;
END SEED_DATA_SPARE_PARTS;
/
