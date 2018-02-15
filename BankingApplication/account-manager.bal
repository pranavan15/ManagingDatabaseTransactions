package BankingApplication;

import ballerina.data.sql;
import ballerina.log;
import BankingApplication.dbUtil;

// Get the SQL client connector
sql:ClientConnector sqlConnector = dbUtil:getDatabaseClientConnector();

// Execute the initialization function
boolean init = initializeDB();

// Function to add users to 'ACCOUNT' table of 'bankDB' database
public function createAccount (string name) (int accId, TypeConversionError conversionErr, TypeCastError castErr) {
    endpoint<sql:ClientConnector> bankDB {
        sqlConnector;
    }

    sql:Parameter username = {sqlType:sql:Type.VARCHAR, value:name};
    sql:Parameter initialBalance = {sqlType:sql:Type.INTEGER, value:0};
    sql:Parameter[] parameters = [username, initialBalance];
    // Insert query
    int rowsAffected = bankDB.update("INSERT INTO ACCOUNT (USERNAME, BALANCE) VALUES (?, ?)", parameters);
    log:printInfo("Creating account for user: '" + name + "'; Rows affected: " + rowsAffected);
    table result = bankDB.select("SELECT LAST_INSERT_ID() AS ACCOUNT_ID", null, null);
    json jsonResult;
    jsonResult, conversionErr = <json>result;
    if (conversionErr == null) {
        accId, castErr = (int)jsonResult[0]["ACCOUNT_ID"];
    }
    return;
}

public function verifyAccount (int accId) (boolean exists, TypeConversionError conversionErr, TypeCastError castErr) {
    endpoint<sql:ClientConnector> bankDB {
        sqlConnector;
    }

    sql:Parameter id = {sqlType:sql:Type.INTEGER, value:accId};
    sql:Parameter[] parameters = [id];
    table result = bankDB.select("SELECT COUNT(*) AS COUNT FROM ACCOUNT WHERE ID = ?", parameters, null);
    json jsonResult;
    int count;
    jsonResult, conversionErr = <json>result;
    if (conversionErr == null) {
        count, castErr = (int)jsonResult[0]["COUNT"];
    }
    exists = <boolean>count;
    return;
}

public function checkBalance (int accId) (int balance, TypeConversionError conversionErr, TypeCastError castErr) {
    endpoint<sql:ClientConnector> bankDB {
        sqlConnector;
    }

    sql:Parameter id = {sqlType:sql:Type.INTEGER, value:accId};
    sql:Parameter[] parameters = [id];
    table result = bankDB.select("SELECT BALANCE FROM ACCOUNT WHERE ID = ?", parameters, null);
    json jsonResult;
    jsonResult, conversionErr = <json>result;
    if (conversionErr == null) {
        balance, castErr = (int)jsonResult[0]["BALANCE"];
    }
    return;
}

public function depositMoney (int accId, int amount) (error err) {
    endpoint<sql:ClientConnector> bankDB {
        sqlConnector;
    }
    if (amount > 0) {
        sql:Parameter id = {sqlType:sql:Type.INTEGER, value:accId};
        sql:Parameter depositAmount = {sqlType:sql:Type.INTEGER, value:amount};
        sql:Parameter[] parameters = [depositAmount, id];
        int rowsAffected = bankDB.update("UPDATE ACCOUNT SET BALANCE = (BALANCE + ?) WHERE ID = ?", parameters);
        log:printInfo("Updating balance for account: " + accId + "; Rows affected: " + rowsAffected);
    }
    else {
        err = {msg:"Cannot deposit money; Invalid amount"};
    }
    return;
}

public function withdrawMoney (int accId, int amount) (error err) {
    endpoint<sql:ClientConnector> bankDB {
        sqlConnector;
    }
    if (amount > 0) {
        sql:Parameter id = {sqlType:sql:Type.INTEGER, value:accId};
        sql:Parameter withdrawAmount = {sqlType:sql:Type.INTEGER, value:amount};
        sql:Parameter[] parameters = [withdrawAmount, id];
        int rowsAffected = bankDB.update("UPDATE ACCOUNT SET BALANCE = (BALANCE - ?) WHERE ID = ?", parameters);
        log:printInfo("Updating balance for account: " + accId + "; Rows affected: " + rowsAffected);
    }
    else {
        err = {msg:"Cannot withdraw money; Invalid amount"};
    }
    return;
}

public function transferMoney (int fromAccId, int toAccId, int amount)  {

}

function initializeDB () (boolean isInitialized) {
    endpoint<sql:ClientConnector> bankDB {
        sqlConnector;
    }
    isInitialized = true;

    // TODO: Uncomment reading config file logic and delete hardcoded value
    // TODO: Currently the problem is Testerina is not reading values from config file - So cannot write test cases
    //string dbName = config:getGlobalValue("DB_NAME");
    string dbName = "bankDB";

    int updateStatus1 = dbUtil:createDatabase(sqlConnector, dbName);
    log:printInfo("---------------------------------- Initialization ----------------------------------");
    log:printInfo("Creating database '" + dbName + "' if not exists; Status: " + updateStatus1);
    int updateStatus2 = bankDB.update("USE " + dbName, null);
    log:printInfo("Selecting database: '" + dbName + "'; Status: " + updateStatus2);
    // Create ACCOUNT table
    int updateStatus3 = bankDB.update("DROP TABLE IF EXISTS ACCOUNT", null);
    log:printInfo("Dropping table 'ACCOUNT' if exists; Status: " + updateStatus3);
    int updateStatus4 = bankDB.update("CREATE TABLE ACCOUNT(ID INT AUTO_INCREMENT, USERNAME VARCHAR(20) NOT NULL,
    BALANCE INT UNSIGNED NOT NULL, PRIMARY KEY (ID))", null);
    log:printInfo("Creating table 'ACCOUNT'; Status: " + updateStatus4 + "\n");

    if (updateStatus1 != 1 && updateStatus2 != 0 && updateStatus3 != 0 && updateStatus4 != 0) {
        isInitialized = false;
    }
    return;
}