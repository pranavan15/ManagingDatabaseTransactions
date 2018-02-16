package BankingApplication;

import ballerina.test;

// TODO: Uncomment tests
// TODO: Currently it's failing as Testerina throws error if a function has a log statement


// Unit test for testing initializeDB function
function testInitializeDB () {
    boolean isInitialized = initializeDB();
    // Initialization expected to be successful
    // Expected boolean value for variable 'isInitialized' is true
    test:assertTrue(isInitialized, "Failed to initialize the database properly");
}

function testCreateAccount () {
    string name = "Carol";
    // Create account for username "Carol"
    int accountId = createAccount(name);
    // 'AUTO_INCREMENT' starts from 1 and default value for int is 0 in Ballerina
    // Therefore, if account creation is successful then variable 'AccountId' should be greater than zero
    test:assertTrue(accountId > 0, "Failed to create account for user: " + name);
}

function testVerifyAccountPass () {
    // Create an account for username "Dave"
    int accountId = createAccount("Dave");
    // Provide an existing account ID to method 'verifyAccount()' - Account ID corresponding to username "Dave"
    boolean accountExists = verifyAccount(accountId);
    // Expected boolean value for variable 'accountExists' is true
    test:assertTrue(accountExists, "Method 'verifyAccount()' is not behaving as intended");
}

function testVerifyAccountFail () {
    // Provide a non existing account ID to method 'verifyAccount()'
    boolean accountExists = verifyAccount(123);
    // Expected boolean value for variable 'accountExists' is false
    test:assertFalse(accountExists, "Method 'verifyAccount()' is not behaving as intended");
}

//function testDepositMoneyPass () {
//    // Create an account for username "Elite"
//    int accountId = createAccount("Elite");
//
//}