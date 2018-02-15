package BankingApplication;

// TODO: Uncomment tests
// TODO: Currently it's failing as Testerina throws error if a function has a log statement


// Unit test for testing initializeDB function
//function testInitializeDB () {
//    boolean isInitialized = initializeDB();
//    test:assertTrue(isInitialized, "Failed to initialize the database properly");
//}

// Unit test for testing initializeDB function
//function testRegisterUsers () {
//    user testUser = {username:"TestUser", password:"Test123", age:21, country:"USA"};
//    user[] userArray = [testUser];
//    int status = registerUsers(userArray);
//    test:assertTrue(status != 0, "Failed to register user");
//}

// Unit test for testing getAllRegisteredUsers function
//function testGetAllRegisteredUsers () {
//    _ = initializeDB();
//    user testUser = {username:"TestUser", password:"Test123", age:25, country:"Sri Lanka"};
//    user[] userArray = [testUser];
//    _ = registerUsers(userArray);
//    var registeredUsers, conversionError = getAllRegisteredUsers();
//    test:assertTrue(conversionError == null, "Error while obtaining registered users from the database");
//    test:assertStringEquals(registeredUsers, "[{\"USERNAME\":\"TestUser\"}]",
//                            "Error while obtaining registered users from the database");
//}