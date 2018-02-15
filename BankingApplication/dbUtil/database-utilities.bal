package BankingApplication.dbUtil;

import ballerina.data.sql;

public function getDatabaseClientConnector () (sql:ClientConnector sqlConnector) {
    // DB configurations
    // TODO: Uncomment reading config file logic and delete hardcoded values
    // TODO: Currently the problem is Testerina is not reading values from config file - So cannot write test cases
    //string dbHost = config:getGlobalValue("DB_HOST");
    //string dbUsername = config:getGlobalValue("DB_USER_NAME");
    //string dbPassword = config:getGlobalValue("DB_PASSWORD");
    //var dbPort, conversionError1 = <int>config:getGlobalValue("DB_PORT");
    //if (conversionError1 != null) {
    //    throw conversionError1;
    //}
    //var dbMaxPoolSize, conversionError2 = <int>config:getGlobalValue("DB_MAX_POOL_SIZE");
    //if (conversionError2 != null) {
    //    throw conversionError2;
    //}

    string dbHost = "localhost";
    string dbUsername = "root";
    string dbPassword = "Mathematics";
    var dbPort = 3306;
    var dbMaxPoolSize = 5;

    // Construct connection URL
    string connectionUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "?useSSL=true";

    // Create SQL connector
    sqlConnector = create sql:ClientConnector(sql:DB.GENERIC, "", 0, "", dbUsername, dbPassword,
                                                                  {url:connectionUrl, maximumPoolSize:dbMaxPoolSize});
    return;
}

public function createDatabase (sql:ClientConnector sqlConnector, string dbName) (int updateStatus) {
    endpoint<sql:ClientConnector> databaseEP {
        sqlConnector;
    }
    updateStatus = databaseEP.update("CREATE DATABASE IF NOT EXISTS " + dbName, null);
    return;
}
