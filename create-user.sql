-- CREATE USER new_user@localhost IDENTIFIED BY "sec_123";

-- SELECT user();

-- GRANT SELECT, INSERT ON voting.* TO "new_user"@"localhost";

-- DROP USER "new_user"@"localhost";

-- CREATE USER secretary_user@localhost IDENTIFIED BY "sec_123";

GRANT SELECT, INSERT ON voting.* TO "secretary_user"@"localhost";
