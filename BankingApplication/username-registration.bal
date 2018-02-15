package BankingApplication;

import ballerina.data.sql;
import ballerina.log;
import BankingApplication.dbUtil;

// Get the SQL client connector
sql:ClientConnector sqlConnector = dbUtil:getDatabaseClientConnector();

// Execute the initialization function
boolean init = initializeDB();

// Function to add users to 'ACCOUNT' table of 'bankDB' database
public function createAccount (string name) (int, TypeConversionError, TypeCastError) {
    endpoint<sql:ClientConnector> bankDB {
        sqlConnector;
    }
    int lastInsertedId;
    TypeConversionError conversionError;
    TypeCastError castError;
    json jsonResult;

    sql:Parameter username = {sqlType:sql:Type.VARCHAR, value:name};
    sql:Parameter initialBalance = {sqlType:sql:Type.INTEGER, value:0};
    sql:Parameter[] parameters = [username, initialBalance];
    // Insert query
    int updateStatus = bankDB.update("INSERT INTO ACCOUNT (USERNAME, BALANCE) VALUES (?, ?)", parameters);
    log:printInfo("Creating account for user: '" + name + "'; Status: " + updateStatus);
    table result = bankDB.select("SELECT LAST_INSERT_ID()", null, null);
    jsonResult, conversionError = <json>result;
    if (conversionError == null) {
        lastInsertedId, castError = (int)jsonResult[0]["LAST_INSERT_ID()"];
    }
    return lastInsertedId, conversionError, castError;
}

function depositMoney (int accountId, int amount) (boolean) {
    endpoint<sql:ClientConnector> bankDB {
        sqlConnector;
    }
    sql:Parameter id = {sqlType:sql:Type.INTEGER, value:accountId};
    sql:Parameter[] selectParameters = [id];
    table selectResult = bankDB.select("SELECT BALANCE FROM ACCOUNT WHERE ID = ?", selectParameters, null);
    var jsonResult, conversionError = <json>selectResult;
    if (conversionError != null) {
        return -1, conversionError, null;
    }
    var lastInsertedId, castError = (int)jsonResult[0]["LAST_INSERT_ID()"];
    if (castError != null) {
        return -1, null, castError;
    }


    sql:Parameter id = {sqlType:sql:Type.VARCHAR, value:accountId};
    sql:Parameter initialBalance = {sqlType:sql:Type.INTEGER, value:0};
    sql:Parameter[] parameters = [username, initialBalance];
    bankDB.update("UPDATE ACCOUNT SET BALANCE = ? WHERE ID = ?")
}

// Function to get the registered users from the 'ACCOUNT' table
public function getAllRegisteredUsers () (string, TypeConversionError) {
    endpoint<sql:ClientConnector> bankDB {
        sqlConnector;
    }
    // Select query
    table dt = bankDB.select("SELECT USERNAME FROM ACCOUNT", null, null);
    // Convert datatable to JSON
    var dtJson, conversionError = <json>dt;
    return dtJson.toString(), conversionError;
}

function initializeDB () (boolean) {
    endpoint<sql:ClientConnector> bankDB {
        sqlConnector;
    }
    boolean isInitialized = true;

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
    return isInitialized;
}