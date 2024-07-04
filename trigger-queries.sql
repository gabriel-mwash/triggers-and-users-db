USE voting;
/*

-- DROP TRIGGER IF EXISTS tr_voter_bi;
-- 
-- DELIMITER //
-- CREATE TRIGGER tr_voter_bi
-- BEFORE INSERT ON race 
-- FOR EACH ROW
-- BEGIN
-- IF user() NOT LIKE "gabu%" THEN
--    SIGNAL SQLSTATE "45000"
--    SET MESSAGE_TEXT="Voter can be added only by the secretary of state";
-- END IF;
-- END //
-- 
-- DELIMITER ;



DROP TRIGGER IF EXISTS tr_ballot_candidate_bi;

DELIMITER // 
CREATE TRIGGER tr_ballot_candidate_bi
BEFORE INSERT ON ballot_candidate
FOR EACH ROW
BEGIN
   DECLARE v_race_id INT;
   DECLARE v_votes_allowed INT;
   DECLARE v_existing_votes INT;
   DECLARE v_error_msg VARCHAR(100);
   DECLARE v_race_name VARCHAR(100);

   SELECT r.race_id, r.votes_allowed
   INTO v_race_id, v_votes_allowed 
   FROM race r 
   JOIN candidate c 
   ON r.race_id = c.race_id 
   WHERE c.candidate_id = new.candidate_id;

   SELECT COUNT(*) 
   INTO v_existing_votes 
   FROM ballot_candidate bc 
   JOIN candidate C
   ON bc.candidate_id = c.candidate_id
   AND c.race_id = v_race_id 
   WHERE bc.ballot_id = new.ballot_id;

   IF v_existing_votes >= v_votes_allowed THEN 
      SELECT concat("Overvoting error: The ", 
         v_race_name, " race allows selecting a maximum of" ,
         v_votes_allowed, " candidate(s) per ballot."
      )

      INTO v_error_msg;

      SIGNAL SQLSTATE "45000" 
      SET MESSAGE_TEXT = v_error_msg;
   END IF;
END //

DELIMITER ;




DROP TRIGGER IF EXISTS tr_voter_bu;

DELIMITER //
CREATE TRIGGER tr_voter_bu 
BEFORE UPDATE ON voter
FOR EACH ROW 
BEGIN
   IF USER() NOT LIKE "gabu%" THEN
      SIGNAL SQLSTATE "45000" 
      SET MESSAGE_TEXT = "Voters can be updated only by gabu";
   END IF;
END //

DELIMITER ;





DROP TRIGGER IF EXISTS tr_race_bu;

DELIMITER //
CREATE TRIGGER tr_race_bu
BEFORE UPDATE ON race
FOR EACH ROW
BEGIN
   IF USER() NOT LIKE "gabu%" THEN
      SIGNAL SQLSTATE "45000" 
      SET MESSAGE_TEXT = "race can be updated only by gabu";
   END IF;
END //

DELIMITER ;




DROP TRIGGER IF EXISTS tr_candidate_bu; 

DELIMITER // 
CREATE TRIGGER tr_candidate_bu 
BEFORE UPDATE ON candidate 
FOR EACH ROW
BEGIN
   IF user() NOT LIKE "gabu%" THEN
      SIGNAL SQLSTATE "45000" 
      SET MESSAGE_TEXT = "candidate can be updated by gabu";
   END IF;
END //

DELIMITER ;


-- AFTER TRIGGERS --
-- after insert triggers(ai)
DROP TRIGGER IF EXISTS tr_voter_ai;
DELIMITER //
CREATE TRIGGER tr_voter_ai 
AFTER INSERT ON voter 
FOR EACH ROW
BEGIN
   INSERT INTO voter_audit 
   (
      audit_datetime, 
      audit_user, 
      audit_change
   )
   VALUES 
   (
      now(), 
      user(), 
      concat(
         "new voter added - ",
         "voter_id: ",                new.voter_id,
         "voter_name: ",              new.voter_name,
         "voter_address: ",           new.voter_address,
         "voter_county: ",            new.voter_county,
         "voter_district: ",          new.voter_district,
         "voter_precinct: ",          new.voter_precinct,
         "voter_party: ",             new.voter_party,
         "voter_location: ",          new.voter_location,
         "voter_registration_num: ",  new.voter_registration_num
      )
   );

END //
DELIMITER ;



DROP TRIGGER IF EXISTS tr_ballot_ai;
DELIMITER //
CREATE TRIGGER tr_ballot_ai 
AFTER INSERT ON ballot
FOR EACH ROW
BEGIN
   INSERT INTO ballot_audit 
   (
      audit_datetime,
      audit_user,
      audit_change
   )
   VALUES
   (
      now(),
      user(),
      concat(
         " ballot added - ",
         " ballot_id: ",      new.ballot_id,     
         " voter_id: ",       new.voter_id,      
         " ballot_type: ",    new.ballot_type,   
         " ballot_cast_dt: ", new.ballot_cast_dt
      )
   );
END //
DELIMITER ;


DROP TRIGGER IF EXISTS tr_race_ai;
DELIMITER // 
CREATE TRIGGER tr_race_ai 
AFTER INSERT ON race 
FOR EACH ROW 
BEGIN 
   INSERT INTO race_audit 
   (
      audit_datetime,
      audit_user,
      audit_change
   )
   VALUES
   (
      now(),
      user(),
      concat(
         "race added- ",
         " race_id: ", new.race_id,      
         " race_name: ", new.race_name,
         " votes_allowed: ", new.votes_allowed
      )
   );
END //
DELIMITER ;


DROP TRIGGER IF EXISTS tr_candidate_ai;
DELIMITER //
CREATE TRIGGER tr_candidate_ai 
AFTER INSERT ON candidate 
FOR EACH ROW
BEGIN 
   INSERT INTO candidate_audit
   (
      audit_datetime,
      audit_user,
      audit_change
   )
   VALUES
   (
      now(),
      user(),
      concat(
         "candidate added - ",
         " candidate_id: ", new.candidate_id,
         " race_id: ", new.race_id,     
         " candidate_name: ", new.candidate_id, 
         " candidate_address: ", new.candidate_address,
         " candidate_party: ", new.candidate_party, 
         " incumbent_flag: ", new.incumbent_flag
      )
   );
END //
DELIMITER ; 


DROP TRIGGER IF EXISTS tr_ballot_candidate_ai;
DELIMITER //
CREATE TRIGGER tr_ballot_candidate_ai
AFTER INSERT ON ballot_candidate 
FOR EACH ROW 
BEGIN 
   INSERT INTO ballot_candidate_audit 
   (
      audit_datetime,
      audit_user,
      audit_change
   )
   VALUES
   (
      now(),
      user(),
      concat(
         "ballot candidate added",
         " ballot_id: ", new.ballot_id,
         " candidate_id: ", new.candidate_id
      )
   );
END //
DELIMITER ;




-- AFTER DELETE TRIGGERS

DROP TRIGGER IF EXISTS tr_voter_ad;
DELIMITER // 
CREATE TRIGGER tr_voter_ad
AFTER DELETE ON voter 
FOR EACH ROW 
BEGIN
   INSERT INTO voter_audit
   (
      audit_datetime,
      audit_user,
      audit_change
   )
   VALUES
   (
      now(),
      user(),
      concat(
         "Voter deleted - ",
         "voter_id: ",                old.voter_id,
         "voter_name: ",              old.voter_name,
         "voter_address: ",           old.voter_address,
         "voter_county: ",            old.voter_county,
         "voter_district: ",          old.voter_district,
         "voter_precinct: ",          old.voter_precinct,
         "voter_party: ",             old.voter_party,
         "voter_location: ",          old.voter_location,
         "voter_registration_num: ",  old.voter_registration_num
      )
   );
END //
DELIMITER ;


DROP TRIGGER IF EXISTS tr_ballot_ad;
DELIMITER //
CREATE TRIGGER tr_ballot_ad 
AFTER DELETE ON ballot 
FOR EACH ROW 
BEGIN
   INSERT INTO ballot
   (
      audit_datetime,
      audit_user,
      audit_change
   )
   VALUES
   (
      now(),
      user(),
      concat(
         " ballot deleted - ",
         " ballot_id: ",      old.ballot_id,    
         " voter_id: ",       old.voter_id,     
         " ballot_type: ",    old.ballot_type,  
         " ballot_cast_dt: ", old.ballot_cast_dt
      )
   );
END //
DELIMITER ;


DROP TRIGGER IF EXISTS tr_race_ad;
DELIMITER //
CREATE TRIGGER tr_race_ad
AFTER DELETE ON race 
FOR EACH ROW
BEGIN
   INSERT INTO race_audit 
   (
      audit_datetime,
      audit_user,
      audit_change
   )
   VALUES
   (
      now(),
      user(),
      concat(
         "race deleted - ",
         " race_id: ",        old.race_id,      
         " race_name: ",      old.race_name,
         " votes_allowed: ",  old.votes_allowed
      )
   );
END //
DELIMITER ;




DROP TRIGGER IF EXISTS tr_candidate_ad;
DELIMITER //
CREATE TRIGGER tr_candidate_ad 
AFTER DELETE ON candidate 
FOR EACH ROW
BEGIN
   INSERT INTO candidate_audit 
   (
      audit_datetime,
      audit_user,
      audit_change
   )
   VALUES
   (
      now(),
      user(),
      concat(
         "candidate deleted - ",
         " candidate_id: ",      old.candidate_id,
         " race_id: ",           old.race_id,     
         " candidate_name: ",    old.candidate_id, 
         " candidate_address: ", old.candidate_address,
         " candidate_party: ",   old.candidate_party, 
         " incumbent_flag: ",    old.incumbent_flag
      )
   );
END //
DELIMITER ;


DROP TRIGGER IF EXISTS tr_ballot_candidate_ad;
DELIMITER //
CREATE TRIGGER tr_ballot_candidate_ad 
AFTER DELETE ON ballot_candidate 
FOR EACH ROW
BEGIN
   INSERT INTO ballot_candidate_audit 
   (
      audit_datetime,
      audit_user,
      audit_change
   )
   VALUES
   (
      now(),
      user(),
      concat(
         "ballot candidate deleted - ",
         " ballot_id: ",      old.ballot_id,
         " candidate_id: ",   old.candidate_id
      )
   );
END //
DELIMITER ;


-- AFTER UPDATE TRIGGERS

DROP TRIGGER if EXISTS tr_voter_au;
DELIMITER //
CREATE TRIGGER tr_voter_au
AFTER UPDATE ON voter
FOR EACH ROW
BEGIN
   SET @change_msg = concat("Voter ", old.voter_id, " Updated: ");

   IF (new.voter_name != old.voter_name ) THEN
      SET @change_msg = 
      concat(@change_msg, "Voter name changed from ",
         old.voter_name, " to ", new.voter_name
      );
   END IF;

   IF (new.voter_address != old.voter_address) THEN
      SET @change_msg = 
      concat(@change_msg, "Voter address changed from ",
         old.voter_address, " to ", new.voter_address
      );
   END IF;

   IF (new.voter_county != old.voter_county) THEN 
      SET @change_msg = 
      concat(@change_msg, "Voter county changed from ",
         old.voter_county, " to ", new.voter_county
      );
   END IF;

   IF (new.voter_district != old.voter_district) THEN 
      SET @change_msg = 
      concat(@change_msg, "Voter district changed from ",
         old.voter_district, " to ", new.voter_district
      );
   END IF;

   IF (new.voter_precinct != old.voter_precinct) THEN 
      SET @change_msg = 
      concat(@change_msg, "voter precinct changed from ",
         old.voter_precinct, " to ", new.voter_precinct
      );
   END IF;

   IF (new.voter_party != old.voter_party) THEN 
      SET @change_msg = 
      concat(@change_msg, "Voter party changed from ",
         old.voter_party, " to ", new.voter_party
      );
   END IF;

   IF (new.voter_location != old.voter_location) THEN 
      set @change_msg = 
      concat(@change_msg, "Voter location changed from ",
         old.voter_location, " to ", new.voter_location
      );
   END IF;

   IF (new.voter_registration_num != old.voter_registration_num) THEN 
      SET @change_msg = 
      concat(@change_msg, "voter registration number changed from ",
         old.voter_registration_num, " to ", new.voter_registration_num
      );
   END IF;

   INSERT INTO voter_audit (audit_datetime, audit_user, audit_change) VALUES (now(), user(), @change_msg);
END //
DELIMITER ;


DESCRIBE ballot;
DROP TRIGGER IF EXISTS tr_ballot_au;
DELIMITER //
CREATE TRIGGER tr_ballot_au 
AFTER UPDATE ON ballot 
FOR EACH ROW
BEGIN
   SET @change_msg = concat("ballot ", old.ballot_id, " Updated :");

   IF (new.ballot_type != old.ballot_type) THEN 
      set @change_msg = 
      concat(@change_msg, "ballot_type changed from ",
         old.ballot_type, " to ", new.ballot_type
      );
   END IF;

   INSERT INTO ballot_audit (audit_datetime, audit_user, audit_change) VALUES (now(), user(), @change_msg);
END //
DELIMITER ;


DROP TRIGGER IF EXISTS tr_race_au;
DELIMITER //
CREATE TRIGGER tr_race_au 
AFTER UPDATE ON race 
FOR EACH ROW
BEGIN 
   SET @change_msg = concat("race ", old.race_id, " updated: ");
   IF (new.race_name != old.race_id ) THEN 
   SET @change_msg = concat(@change_msg," race_name changed from ",  
         old.race_name, " to ", new.race_name);
   END IF;

   IF (new.votes_allowed != old.votes_allowed) THEN 
      SET @change_msg = concat(@change_msg, " votes_allowed changed from ", 
         old.votes_allowed, " to ", new.votes_allowed);
   END IF;
   
   INSERT INTO race_audit (audit_datetime, audit_user, audit_change) VALUES (now(), user(), @change_msg);
END //
DELIMITER ;
   

DROP TRIGGER IF EXISTS tr_candidate_au;
DELIMITER // 
CREATE TRIGGER tr_candidate_au 
AFTER UPDATE ON candidate 
FOR EACH ROW 
BEGIN 
   SET @change_msg = concat("Candidiate ", old.candidate_id, " updated: ");

   IF (new.candidate_name != old.candidate_name) THEN 
   SET @change_msg =  concat(@change_msg, "candidate_name changed from ",
      old.candidate_name, " to ", new.candidate_name);
   END IF;

   IF (new.candidate_address != old.candidate_address) THEN 
   SET @change_msg =  concat(@change_msg, " candidate_address changed from ",
      old.candidate_address, " to ", new.candidate_address);
   END IF;

   IF (new.candidate_party != old.candidate_party) THEN 
   SET @change_msg =  concat(@change_msg, "candidate_party changed from ",
      old.candidate_party, " to ", new.candidate_party);
   END IF;
      
   IF (new.incumbent_flag != old.incumbent_flag) THEN 
   SET @change_msg =  concat(@change_msg, "incumbent_flag changed from ",
      old.incumbent_flag, " to ", new.incumbent_flag);
   END IF;

   INSERT INTO candidate_audit (audit_datetime, audit_user, audit_change) VALUES (now(), user(), @change_msg);
END //
DELIMITER ;


DROP TRIGGER IF EXISTS ballot_candidate_au;
DELIMITER // 
CREATE TRIGGER ballot_candidate_au 
AFTER UPDATE ON ballot_candidate 
FOR EACH ROW
BEGIN
   SET @change_msg = concat("ballot ", old.ballot_id, "updated ");

   IF (old.ballot_id != new.ballot_id) THEN
   SET @change_msg = concat(@change_msg, "ballot id changed from " ,
      old.ballot_id, " to " , new.ballot_id);
   END IF;

   IF (old.candidate_id != new.candidate_id) THEN 
   SET @change_msg = concat(@change_msg, "candidate id changed from ", 
      old.candidate_id, " to " , new.candidate_id);
   END if;

   INSERT INTO ballot_candidate_audit (audit_datetime, audit_user, audit_change) VALUES (now(), user(), @change_msg);
END //
DELIMITER ;
*/ 

   








