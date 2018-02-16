package BankingApplication;

import ballerina.data.sql;
import ballerina.log;
import BankingApplication.dbUtil;

// Get the SQL client connector
sql:ClientConnector sqlConnector = dbUtil:getDatabaseClientConnector();

// Execute the initialization function
boolean init = initializeDB();

// Function to add users to 'ACCOUNT' table of 'bankDB' database
public function createAccount (string name) (int accId) {
    endpoint<sql:ClientConnector> bankDB {
        sqlConnector;
    }
    sql:Parameter username = {sqlType:sql:Type.VARCHAR, value:name};
    sql:Parameter initialBalance = {sqlType:sql:Type.INTEGER, value:0};
    sql:Parameter[] parameters = [username, initialBalance];
    // Insert query
    int rowsAffected = bankDB.update("INSERT INTO ACCOUNT (USERNAME, BALANCE) VALUES (?, ?)", parameters);
    log:printInfo("Creating account for user: '" + name + "'; Rows affected in ACCOUNT table: " + rowsAffected);
    table result = bankDB.select("SELECT LAST_INSERT_ID() AS ACCOUNT_ID", null, null);
    var jsonResult, _ = <json>result;
    accId, _ = (int)jsonResult[0]["ACCOUNT_ID"];
    log:printInfo("Account ID for user: '" + name + "': " + accId);
    return;
}

public function verifyAccount (int accId) (boolean accExists) {
    endpoint<sql:ClientConnector> bankDB {
        sqlConnector;
    }
    log:printInfo("Verifying whether account ID " + accId + " exists");
    sql:Parameter id = {sqlType:sql:Type.INTEGER, value:accId};
    sql:Parameter[] parameters = [id];
    table result = bankDB.select("SELECT COUNT(*) AS COUNT FROM ACCOUNT WHERE ID = ?", parameters, null);
    var jsonResult, _ = <json>result;
    var count, _ = (int)jsonResult[0]["COUNT"];
    accExists = <boolean>count;
    return;
}

public function checkBalance (int accId) (int balance, error err) {
    endpoint<sql:ClientConnector> bankDB {
        sqlConnector;
    }
    log:printInfo("Checking balance for account ID: " + accId);
    if (!verifyAccount(accId)) {
        err = {msg:"Error: Account does not exist"};
        return;
    }
    sql:Parameter id = {sqlType:sql:Type.INTEGER, value:accId};
    sql:Parameter[] parameters = [id];
    table result = bankDB.select("SELECT BALANCE FROM ACCOUNT WHERE ID = ?", parameters, null);
    var jsonResult, _ = <json>result;
    balance, _ = (int)jsonResult[0]["BALANCE"];
    log:printInfo("Available balance in account ID " + accId + ": " + balance);
    return;
}

public function depositMoney (int accId, int amount) (error err) {
    endpoint<sql:ClientConnector> bankDB {
        sqlConnector;
    }
    log:printInfo("Depositing money to account ID: " + accId);
    if (amount <= 0) {
        err = {msg:"Error: Invalid amount"};
        return;
    }
    if (!verifyAccount(accId)) {
        err = {msg:"Error: Account does not exist"};
        return;
    }
    sql:Parameter id = {sqlType:sql:Type.INTEGER, value:accId};
    sql:Parameter depositAmount = {sqlType:sql:Type.INTEGER, value:amount};
    sql:Parameter[] parameters = [depositAmount, id];
    int rowsAffected = bankDB.update("UPDATE ACCOUNT SET BALANCE = (BALANCE + ?) WHERE ID = ?", parameters);
    log:printInfo("Updating balance for account ID: " + accId + "; Rows affected in ACCOUNT table: " + rowsAffected);
    log:printInfo("$" + amount + " has been deposited to account ID " + accId);
    return;
}

public function withdrawMoney (int accId, int amount) (error err) {
    endpoint<sql:ClientConnector> bankDB {
        sqlConnector;
    }
    log:printInfo("Withdrawing money from account ID: " + accId);
    if (amount <= 0) {
        err = {msg:"Error: Invalid amount"};
        return;
    }
    var balance, checkBalanceError = checkBalance(accId);
    if (checkBalanceError != null) {
        err = checkBalanceError;
        return;
    }
    if (balance < amount) {
        err = {msg:"Error: Not enough balance"};
        return;
    }
    sql:Parameter id = {sqlType:sql:Type.INTEGER, value:accId};
    sql:Parameter withdrawAmount = {sqlType:sql:Type.INTEGER, value:amount};
    sql:Parameter[] parameters = [withdrawAmount, id];
    int rowsAffected = bankDB.update("UPDATE ACCOUNT SET BALANCE = (BALANCE - ?) WHERE ID = ?", parameters);
    log:printInfo("Updating balance for account ID: " + accId + "; Rows affected in ACCOUNT table: " + rowsAffected);
    log:printInfo("$" + amount + " has been withdrawn from account ID " + accId);
    return;
}

public function transferMoney (int fromAccId, int toAccId, int amount) (boolean isSuccessful) {
    transaction with retries(0) {
        log:printInfo("Initiating transaction");
        log:printInfo("Transferring money from account ID " + fromAccId + " to account ID " + toAccId);
        error withdrawError = withdrawMoney(fromAccId, amount);
        if (withdrawError != null) {
            log:printError("Error while withdrawing the money: " + withdrawError.msg);
            abort;
        }
        error depositError = depositMoney(toAccId, amount);
        if (depositError != null) {
            log:printError("Error while depositing the money: " + depositError.msg);
            abort;
        }
        isSuccessful = true;
        log:printInfo("Transaction committed");
        log:printInfo("Successfully transferred $" + amount + " from account ID " + fromAccId + " to account ID " +
                      toAccId);
    } failed {
        log:printError("Error while transferring money from account ID " + fromAccId + " to account ID " + toAccId);
        log:printError("Transaction failed");
    }
    return isSuccessful;
}

function initializeDB () (boolean isInitialized) {
    endpoint<sql:ClientConnector> bankDB {
        sqlConnector;
    }

    // TODO: Uncomment reading config file logic and delete hardcoded value
    // TODO: Currently the problem is Testerina is not reading values from config file - So cannot write test cases
    //string dbName = config:getGlobalValue("DB_NAME");
    string dbName = "bankDB";

    int updateStatus1 = dbUtil:createDatabase(sqlConnector, dbName);
    log:printInfo("------------------------------- DB Initialization -------------------------------");
    log:printInfo("Creating database '" + dbName + "' if not exists; Status: " + updateStatus1);
    int updateStatus2 = bankDB.update("USE " + dbName, null);
    log:printInfo("Selecting database: '" + dbName + "'; Status: " + updateStatus2);
    // Create ACCOUNT table
    int updateStatus3 = bankDB.update("DROP TABLE IF EXISTS ACCOUNT", null);
    log:printInfo("Dropping table 'ACCOUNT' if exists; Status: " + updateStatus3);
    int updateStatus4 = bankDB.update("CREATE TABLE ACCOUNT(ID INT AUTO_INCREMENT, USERNAME VARCHAR(20) NOT NULL,
    BALANCE INT UNSIGNED NOT NULL, PRIMARY KEY (ID))", null);
    log:printInfo("Creating table 'ACCOUNT'; Status: " + updateStatus4 + "\n");

    if (updateStatus1 == 1 && updateStatus2 == 0 && updateStatus3 == 0 && updateStatus4 == 0) {
        isInitialized = true;
    }
    return;
}