package BankingApplication.dbUtil;

import ballerina.data.sql;
import ballerina.config;

public function getDatabaseClientConnector () (sql:ClientConnector sqlConnector) {
    // DB configurations
    string dbHost = config:getGlobalValue("DATABASE_HOST");
    string dbUsername = config:getGlobalValue("DATABASE_USERNAME");
    string dbPassword = config:getGlobalValue("DATABASE_PASSWORD");
    var dbPort, conversionError1 = <int>config:getGlobalValue("DATABASE_PORT");
    if (conversionError1 != null) {
        throw conversionError1;
    }
    var dbMaxPoolSize, conversionError2 = <int>config:getGlobalValue("DATABASE_MAX_POOL_SIZE");
    if (conversionError2 != null) {
        throw conversionError2;
    }

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
