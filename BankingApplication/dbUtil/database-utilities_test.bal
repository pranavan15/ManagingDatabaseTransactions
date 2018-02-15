package BankingApplication.dbUtil;

import ballerina.data.sql;
import ballerina.test;

// Unit test for testing getDatabaseClientConnector function
function testGetDatabaseClientConnector () {
    sql:ClientConnector sqlConnector = getDatabaseClientConnector();
    test:assertTrue(sqlConnector != null, "Cannot obtain database client connector");
}

// Unit test for testing createDatabase function
function testCreateDatabase () {
    sql:ClientConnector sqlConnector = getDatabaseClientConnector();
    int status = createDatabase(sqlConnector, "testDB");
    test:assertTrue(status == 1, "Cannot execute the 'create database' query properly");
}
