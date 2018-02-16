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
2018-02-16 07:16:33,259 INFO  [BankingApplication] - ------------------------------- DB Initialization ------------------------------- 
2018-02-16 07:16:33,264 INFO  [BankingApplication] - Creating database 'bankDB' if not exists; Status: 1 
2018-02-16 07:16:33,265 INFO  [BankingApplication] - Selecting database: 'bankDB'; Status: 0 
2018-02-16 07:16:33,289 INFO  [BankingApplication] - Dropping table 'ACCOUNT' if exists; Status: 0 
2018-02-16 07:16:33,323 INFO  [BankingApplication] - Creating table 'ACCOUNT'; Status: 0
 
2018-02-16 07:16:33,330 INFO  [BankingApplication] - ---------------------------------------------------------------------------------- 
2018-02-16 07:16:33,330 INFO  [BankingApplication] - Creating two new accounts for users 'Alice' and 'Bob' 
2018-02-16 07:16:33,341 INFO  [BankingApplication] - Creating account for user: 'Alice'; Rows affected in ACCOUNT table: 1 
2018-02-16 07:16:33,514 INFO  [BankingApplication] - Account ID for user: 'Alice': 1 
2018-02-16 07:16:33,519 INFO  [BankingApplication] - Creating account for user: 'Bob'; Rows affected in ACCOUNT table: 1 
2018-02-16 07:16:33,521 INFO  [BankingApplication] - Account ID for user: 'Bob': 2 
2018-02-16 07:16:33,522 INFO  [BankingApplication] - Deposit $500 to Alice's account initially 
2018-02-16 07:16:33,522 INFO  [BankingApplication] - Depositing money to account ID: 1 
2018-02-16 07:16:33,522 INFO  [BankingApplication] - Verifying whether account ID 1 exists 
2018-02-16 07:16:33,530 INFO  [BankingApplication] - Updating balance for account ID: 1; Rows affected in ACCOUNT table: 1 
2018-02-16 07:16:33,531 INFO  [BankingApplication] - $500 has been deposited to account ID 1 
2018-02-16 07:16:33,531 INFO  [BankingApplication] - Deposit $1000 to Bob's account initially 
2018-02-16 07:16:33,531 INFO  [BankingApplication] - Depositing money to account ID: 2 
2018-02-16 07:16:33,532 INFO  [BankingApplication] - Verifying whether account ID 2 exists 
2018-02-16 07:16:33,537 INFO  [BankingApplication] - Updating balance for account ID: 2; Rows affected in ACCOUNT table: 1 
2018-02-16 07:16:33,537 INFO  [BankingApplication] - $1000 has been deposited to account ID 2 
2018-02-16 07:16:33,537 INFO  [BankingApplication] - 

--------------------------------------------------------------- Scenario 1-------------------------------------------------------------- 
2018-02-16 07:16:33,538 INFO  [BankingApplication] - Transfer $300 from Alice's account to Bob's account 
2018-02-16 07:16:33,538 INFO  [BankingApplication] - Expected: Transaction to be successful 
2018-02-16 07:16:33,539 INFO  [BankingApplication] - Initiating transaction 
2018-02-16 07:16:33,540 INFO  [BankingApplication] - Transfering money from account ID 1 to account ID 2 
2018-02-16 07:16:33,541 INFO  [BankingApplication] - Withdrawing money from account ID: 1 
2018-02-16 07:16:33,541 INFO  [BankingApplication] - Checking balance for account ID: 1 
2018-02-16 07:16:33,541 INFO  [BankingApplication] - Verifying whether account ID 1 exists 
2018-02-16 07:16:33,544 INFO  [BankingApplication] - Available balance in account ID 1: 500 
2018-02-16 07:16:33,545 INFO  [BankingApplication] - Updating balance for account ID: 1; Rows affected in ACCOUNT table: 1 
2018-02-16 07:16:33,545 INFO  [BankingApplication] - $300 has been withdrawn from account ID 1 
2018-02-16 07:16:33,545 INFO  [BankingApplication] - Depositing money to account ID: 2 
2018-02-16 07:16:33,546 INFO  [BankingApplication] - Verifying whether account ID 2 exists 
2018-02-16 07:16:33,549 INFO  [BankingApplication] - Updating balance for account ID: 2; Rows affected in ACCOUNT table: 1 
2018-02-16 07:16:33,549 INFO  [BankingApplication] - $300 has been deposited to account ID 2 
2018-02-16 07:16:33,550 INFO  [BankingApplication] - Transaction committed 
2018-02-16 07:16:33,550 INFO  [BankingApplication] - Successfully transferred $300 from account ID 1 to account ID 2 
2018-02-16 07:16:33,555 INFO  [BankingApplication] - Check balance for Alice's account 
2018-02-16 07:16:33,556 INFO  [BankingApplication] - Checking balance for account ID: 1 
2018-02-16 07:16:33,556 INFO  [BankingApplication] - Verifying whether account ID 1 exists 
2018-02-16 07:16:33,559 INFO  [BankingApplication] - Available balance in account ID 1: 200 
2018-02-16 07:16:33,559 INFO  [BankingApplication] - You should see $200 balance in Alice's account 
2018-02-16 07:16:33,560 INFO  [BankingApplication] - Check balance for Bob's account 
2018-02-16 07:16:33,560 INFO  [BankingApplication] - Checking balance for account ID: 2 
2018-02-16 07:16:33,561 INFO  [BankingApplication] - Verifying whether account ID 2 exists 
2018-02-16 07:16:33,563 INFO  [BankingApplication] - Available balance in account ID 2: 1300 
2018-02-16 07:16:33,564 INFO  [BankingApplication] - You should see $1300 balance in Bob's account 
2018-02-16 07:16:33,564 INFO  [BankingApplication] - 

--------------------------------------------------------------- Scenario 2-------------------------------------------------------------- 
2018-02-16 07:16:33,564 INFO  [BankingApplication] - Again try to transfer $500 from Alice's account to Bob's account 
2018-02-16 07:16:33,565 INFO  [BankingApplication] - Expected: Transaction to fail as Alice now only has a balance of $200 in account 
2018-02-16 07:16:33,565 INFO  [BankingApplication] - Initiating transaction 
2018-02-16 07:16:33,565 INFO  [BankingApplication] - Transfering money from account ID 1 to account ID 2 
2018-02-16 07:16:33,566 INFO  [BankingApplication] - Withdrawing money from account ID: 1 
2018-02-16 07:16:33,566 INFO  [BankingApplication] - Checking balance for account ID: 1 
2018-02-16 07:16:33,566 INFO  [BankingApplication] - Verifying whether account ID 1 exists 
2018-02-16 07:16:33,569 INFO  [BankingApplication] - Available balance in account ID 1: 200 
2018-02-16 07:16:33,570 ERROR [BankingApplication] - Error while withdrawing the money: Error: Not enough balance 
2018-02-16 07:16:33,570 INFO  [BankingApplication] - Check balance for Alice's account 
2018-02-16 07:16:33,571 INFO  [BankingApplication] - Checking balance for account ID: 1 
2018-02-16 07:16:33,571 INFO  [BankingApplication] - Verifying whether account ID 1 exists 
2018-02-16 07:16:33,574 INFO  [BankingApplication] - Available balance in account ID 1: 200 
2018-02-16 07:16:33,574 INFO  [BankingApplication] - You should see $200 balance in Alice's account 
2018-02-16 07:16:33,574 INFO  [BankingApplication] - Check balance for Bob's account 
2018-02-16 07:16:33,575 INFO  [BankingApplication] - Checking balance for account ID: 2 
2018-02-16 07:16:33,575 INFO  [BankingApplication] - Verifying whether account ID 2 exists 
2018-02-16 07:16:33,577 INFO  [BankingApplication] - Available balance in account ID 2: 1300 
2018-02-16 07:16:33,578 INFO  [BankingApplication] - You should see $1300 balance in Bob's account 
2018-02-16 07:16:33,578 INFO  [BankingApplication] - 

--------------------------------------------------------------- Scenario 3-------------------------------------------------------------- 
2018-02-16 07:16:33,578 INFO  [BankingApplication] - Try to transfer $500 from Bob's account to a non existing account ID 
2018-02-16 07:16:33,579 INFO  [BankingApplication] - Expected: Transaction to fail as account ID of recipient is invalid 
2018-02-16 07:16:33,579 INFO  [BankingApplication] - Initiating transaction 
2018-02-16 07:16:33,579 INFO  [BankingApplication] - Transfering money from account ID 2 to account ID 123 
2018-02-16 07:16:33,580 INFO  [BankingApplication] - Withdrawing money from account ID: 2 
2018-02-16 07:16:33,580 INFO  [BankingApplication] - Checking balance for account ID: 2 
2018-02-16 07:16:33,580 INFO  [BankingApplication] - Verifying whether account ID 2 exists 
2018-02-16 07:16:33,583 INFO  [BankingApplication] - Available balance in account ID 2: 1300 
2018-02-16 07:16:33,584 INFO  [BankingApplication] - Updating balance for account ID: 2; Rows affected in ACCOUNT table: 1 
2018-02-16 07:16:33,584 INFO  [BankingApplication] - $500 has been withdrawn from account ID 2 
2018-02-16 07:16:33,585 INFO  [BankingApplication] - Depositing money to account ID: 123 
2018-02-16 07:16:33,585 INFO  [BankingApplication] - Verifying whether account ID 123 exists 
2018-02-16 07:16:33,589 ERROR [BankingApplication] - Error while depositing the money: Error: Account does not exist 
2018-02-16 07:16:33,598 INFO  [BankingApplication] - Check balance for Bob's account 
2018-02-16 07:16:33,598 INFO  [BankingApplication] - Checking balance for account ID: 2 
2018-02-16 07:16:33,598 INFO  [BankingApplication] - Verifying whether account ID 2 exists 
2018-02-16 07:16:33,601 INFO  [BankingApplication] - Available balance in account ID 2: 1300 
2018-02-16 07:16:33,601 INFO  [BankingApplication] - You should see $1300 balance in Bob's account (NOT $800) 
2018-02-16 07:16:33,601 INFO  [BankingApplication] - Explanation: When trying to transfer $500 from Bob's account to account ID 123, 
initially $500withdrawed from Bob's account. But then the deposit operation failed due to an invalid recipientaccount ID; Hence 
the TX failed and the withdraw operation rollbacked, which is in the same TX
 
2018-02-16 07:16:33,601 INFO  [BankingApplication] - 
---------------------------------------------------------------------------------------------------------------------------------------- 

```
