/*
USE voting;

-- DDL data definition language
CREATE TABLE voter 
(
   voter_id                INT             PRIMARY KEY  AUTO_INCREMENT,
   voter_name              VARCHAR(100)    NOT NULL,
   voter_address           VARCHAR(100)    NOT NULL,
   voter_county            VARCHAR(100)    NOT NULL,
   voter_district          VARCHAR(100)    NOT NULL,
   voter_precinct          VARCHAR(100)    NOT NULL,
   voter_party             VARCHAR(100),
   voter_location          VARCHAR(100)    NOT NULL,
   voter_registration_num  INT             NOT NULL     UNIQUE 
);

CREATE TABLE ballot
(
   ballot_id            INT          PRIMARY KEY  AUTO_INCREMENT,
   voter_id             INT          NOT NULL     UNIQUE,
   ballot_type          VARCHAR(10)  NOT NULL,
   ballot_cast_dt       DATETIME     NOT NULL     DEFAULT NOW(),

   CONSTRAINT FOREIGN KEY(voter_id) REFERENCES voter(voter_id),
   CONSTRAINT CHECK(ballot_type IN ("in-person", "absentee"))
);

CREATE TABLE race 
(
   race_id        INT            PRIMARY KEY  AUTO_INCREMENT,
   race_name      VARCHAR(100)   NOT NULL     UNIQUE,
   votes_allowed  INT            NOT NULL
);


CREATE TABLE candidate
(
   candidate_id       INT            PRIMARY KEY    AUTO_INCREMENT,
   race_id            INT            NOT NULL,
   candidate_name     VARCHAR(100)   NOT NULL,
   candidate_address  VARCHAR(100),
   candidate_party    VARCHAR(20),
   incumbent_flag     BOOL,

   CONSTRAINT FOREIGN KEY(race_id) REFERENCES race(race_id)
);


CREATE TABLE ballot_candidate
(
   ballot_id      INT,
   candidate_id   INT,

   PRIMARY KEY (ballot_id, candidate_id),
   CONSTRAINT FOREIGN KEY (ballot_id) REFERENCES ballot(ballot_id),
   CONSTRAINT FOREIGN KEY (candidate_id) REFERENCES candidate(candidate_id)
);


-- audit tables 
DESCRIBE voter;

CREATE TABLE voter_audit
(
   audit_datetime DATETIME,
   audit_user VARCHAR(100),
   audit_change VARCHAR(1000)
);

CREATE TABLE ballot_audit
(
   audit_datetime DATETIME,
   audit_user VARCHAR(100),
   audit_change VARCHAR(1000)
);

CREATE TABLE race_audit 
(
   audit_datetime DATETIME,
   audit_user VARCHAR(100),
   audit_change VARCHAR(1000)
);

CREATE TABLE candidate_audit
(
   audit_datetime DATETIME,
   audit_user VARCHAR(100),
   audit_change VARCHAR(1000)
); 

CREATE TABLE ballot_candidate_audit
(
   audit_datetime DATETIME,
   audit_user VARCHAR(100),
   audit_change VARCHAR(1000)
);
*/


DESCRIBE voter;
