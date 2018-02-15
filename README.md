# Transaction Processing Using Ballerina
This is a use-case example that explains How to manage transactions in Ballerina language (https://ballerinalang.org).

# About This Service 
This is a user registration system where each user needs to register with a unique username. To demonstrate the
ballerina transaction, 3 different sets of user registrations illustrated in this example. Each set of registration is 
handled through a specific transaction. First transaction is expected to be successful. Other two are expected to fail
due to database constraint violations. This example clearly explains what happen when a transaction fails and how 
to manage transactions using ballerina language.

# How to Deploy
1) Go to http://www.ballerinalang.org and click Download.
2) Download the Ballerina Tools distribution and unzip it on your computer. Ballerina Tools includes the Ballerina runtime plus
the visual editor (Composer) and other tools.
3) Add the <ballerina_home>/bin directory to your $PATH environment variable so that you can run the Ballerina commands from anywhere.
4) After setting up <ballerina_home>, navigate to the folder containing `UserRegistration.bal` file and run: `$ ballerina run UserRegistration.bal` 

# Response You Will Get

```
2018-02-12 22:07:09,774 INFO  [userRegistrationSystem] - ---------------------------------- Initialization ---------------------------------- 
2018-02-12 22:07:09,776 INFO  [userRegistrationSystem] - Creating database 'userDB' if not exists - Status: 1 
2018-02-12 22:07:09,777 INFO  [userRegistrationSystem] - Selecting database userDB - status: 0 
2018-02-12 22:07:09,797 INFO  [userRegistrationSystem] - Dropping table 'USERINFO' if exists - Status: 0 
2018-02-12 22:07:09,826 INFO  [userRegistrationSystem] - Creating table 'USERINFO' - Status: 0
 
2018-02-12 22:07:09,831 INFO  [userRegistrationSystem] - ---------------------------------- Transaction 1 ---------------------------------- 
2018-02-12 22:07:09,837 INFO  [userRegistrationSystem] - Registering 'Alice' and 'Bob' 
2018-02-12 22:07:09,850 INFO  [userRegistrationSystem] - Transaction successful 
2018-02-12 22:07:09,852 INFO  [userRegistrationSystem] - 'Alice' and 'Bob' have succesfully registered 
2018-02-12 22:07:09,855 INFO  [userRegistrationSystem] - Transaction committed 
2018-02-12 22:07:10,059 INFO  [userRegistrationSystem] - Registered users: [{"USERNAME":"Alice"},{"USERNAME":"Bob"}] 
2018-02-12 22:07:10,060 INFO  [userRegistrationSystem] - Expected Results: You should see 'Alice' and 'Bob'
 
2018-02-12 22:07:10,060 INFO  [userRegistrationSystem] - ---------------------------------- Transaction 2 ---------------------------------- 
2018-02-12 22:07:10,060 INFO  [userRegistrationSystem] - Registering 'Alice' and 'Charles' 
2018-02-12 22:07:10,077 ERROR [userRegistrationSystem] - Transaction failed 
2018-02-12 22:07:10,078 INFO  [userRegistrationSystem] - Above error occured as expected: username 'Alice' is already taken 
2018-02-12 22:07:10,079 INFO  [userRegistrationSystem] - Registered users: [{"USERNAME":"Alice"},{"USERNAME":"Bob"}]
Expected Results: You shouldn't see 'charles'. Attempt to reuse username 'Alice' is a DB constraint violation. Therefore, 'Charles' was rolled back in the same TX
 
2018-02-12 22:07:10,079 INFO  [userRegistrationSystem] - ---------------------------------- Transaction 3 ---------------------------------- 
2018-02-12 22:07:10,080 INFO  [userRegistrationSystem] - Registering 'Dias' and 'UserWhoLovesCats' 
2018-02-12 22:07:10,085 ERROR [userRegistrationSystem] - Transaction failed 
2018-02-12 22:07:10,086 INFO  [userRegistrationSystem] - Above error occured as expected: username 'UserWhoLovesCats' is too big (Atmost 10 characters) 
2018-02-12 22:07:10,088 INFO  [userRegistrationSystem] - Registered users: [{"USERNAME":"Alice"},{"USERNAME":"Bob"}]
Expected Results: You shouldn't see 'Dias' and 'UserWhoLovesCats'. 'UserWhoLovesCats' violated DB constraints, and 'Dias' was rolled back in the same TX
```
