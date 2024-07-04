-- DML data manipulation language
/*
USE voting;

INSERT INTO voter 
(
   voter_name,
   voter_address,
   voter_county,
   voter_district,
   voter_precinct,
   voter_party,
   voter_location,
   voter_registration_num
)
VALUES
(
   "Susan King",
   "12 Pleasant St. Springfield",
   "Franklin",
   "12A",
   "4C",
   "Democrat",
   "523 Emerson St. ",
   129756
);

-- ALTER TABLE race AUTO_INCREMENT=1;

INSERT INTO ballot
(
   voter_id,
   ballot_type,
   ballot_cast_dt
)
VALUES 
(
   1,
   "in-person", 
   now()
);

UPDATE voter 
SET voter_name = "Leah J. Kennedy",
voter_party = "Republican" 
WHERE voter_id = 1;

SELECT * FROM voter;
SELECT * FROM voter_audit;

UPDATE ballot 
SET ballot_type = "absentee" 
WHERE ballot_id = 2;
SELECT * FROM ballot;
SELECT * FROM ballot_audit;
*/

DESCRIBE ballot_candidate;








