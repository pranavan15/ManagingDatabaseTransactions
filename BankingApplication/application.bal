package BankingApplication;

//import ballerina.log;
//
//function main (string[] args) {
//    // Transaction 1 - Expected to be successful
//    log:printInfo("---------------------------------- Transaction 1 ----------------------------------");
//    user user1 = {username:"Alice", password:"Alice123", age:20, country:"USA"};
//    user user2 = {username:"Bob", password:"bob123", age:21, country:"UK"};
//    user[] usersArray1 = [user1, user2];
//    transaction with retries(0) {
//        log:printInfo("Registering 'Alice' and 'Bob'");
//        int updateStatus = createAccount(usersArray1);
//        // If update fails, abort the transaction
//        if (updateStatus == 0) {
//            abort;
//        }
//        // Expected Results
//        log:printInfo("Transaction successful");
//        log:printInfo("'Alice' and 'Bob' have succesfully registered");
//        log:printInfo("Transaction committed");
//    } failed {
//        log:printError("Transaction failed");
//    }
//    var registeredUsers1, conversionError1 = getAllRegisteredUsers();
//    if (conversionError1 != null) {
//        log:printError("Error while retriving registered users: " + conversionError1.msg);
//    }
//    log:printInfo("Registered users: " + registeredUsers1);
//    log:printInfo("Expected Results: You should see 'Alice' and 'Bob'\n");
//
//    // Transaction 2 - Expected to fail
//    log:printInfo("---------------------------------- Transaction 2 ----------------------------------");
//    user user3 = {username:"Charles", password:"Charles123", age:25, country:"India"};
//    user user4 = {username:"Alice", password:"AliceNew123", age:32, country:"Sri Lanka"};
//    user[] usersArray2 = [user3, user4];
//    try {
//        transaction with retries(0) {
//            log:printInfo("Registering 'Alice' and 'Charles'");
//            int updateStatus = createAccount(usersArray2);
//            // If update fails, abort the transaction
//            if (updateStatus == 0) {
//                abort;
//            }
//            log:printInfo("Transaction committed");
//        } failed {
//            // Expected Results
//            log:printError("Transaction failed");
//        }
//    } catch (error err) {
//        log:printInfo("Above error occurred as expected: username 'Alice' is already taken");
//    }
//    var registeredUsers2, conversionError2 = getAllRegisteredUsers();
//    if (conversionError2 != null) {
//        log:printError("Error while retriving registered users: " + conversionError2.msg);
//    }
//    log:printInfo("Registered users: " + registeredUsers2 + "\n" +
//                  "Expected Results: You shouldn't see 'charles'. " +
//                  "Attempt to reuse username 'Alice' is a DB constraint violation. " +
//                  "Therefore, 'Charles' was rolled back in the same TX\n");
//
//    // Transaction 3 - Expected to fail
//    log:printInfo("---------------------------------- Transaction 3 ----------------------------------");
//    user user5 = {username:"Dias", password:"Dias123", age:24, country:"Sri Lanka"};
//    user user6 = {username:"UserWhoLovesCats", password:"ABC123", age:27, country:"India"};
//    user[] usersArray3 = [user5, user6];
//    try {
//        transaction with retries(0) {
//            log:printInfo("Registering 'Dias' and 'UserWhoLovesCats'");
//            int updateStatus = createAccount(usersArray3);
//            // If update fails, abort the transaction
//            if (updateStatus == 0) {
//                abort;
//            }
//            log:printInfo("Transaction committed");
//        } failed {
//            // Expected Results
//            log:printError("Transaction failed");
//        }
//    } catch (error err) {
//        log:printInfo("Above error occurred as expected: username 'UserWhoLovesCats' is too big (Atmost 10 characters)");
//    }
//    var registeredUsers3, conversionError3 = getAllRegisteredUsers();
//    if (conversionError3 != null) {
//        log:printError("Error while retriving registered users: " + conversionError3.msg);
//    }
//    log:printInfo("Registered users: " + registeredUsers3 + "\n" +
//                  "Expected Results: You shouldn't see 'Dias' and 'UserWhoLovesCats'. " +
//                  "'UserWhoLovesCats' violated DB constraints, and 'Dias' was rolled back in the same TX\n");
//}

function main (string[] args) {
    _ = initializeDB ();
    _, _, _ = createAccount("Pranavan");
}

