# Managing Database Transactions
In this guide you will learn about managing database transactions using Ballerina.

## <a name="what-you-build"></a> What you’ll build 
To understanding how you can manage database transactions using Ballerina, let’s consider a real world use case of a simple banking appliacation. This simple banking application allows users to,

- **Create accounts** : Create a new account by providing username
- **Verify accounts** : Verify the existance of an account by providing the account Id
- **Check balance** : Check account balance
- **Deposit money** : Deposit money to an account
- **Withdraw money** : Withdraw money from an account
- **Transfer money** : Transfer money from one account to another account


Transfering money from one account to another account includes both operations, withdrawal from transferor and deposit to transferee. Thus, transferring operation required to be done using a transaction block. A transaction will ensure the 'ACID'properties, which is a set of properties of database transactions intended to guarantee validity even in the event of errors, power failures, etc.

For example, when transferring money if the transaction fails during deposit operation, then the withdrawal operation that carried out prior to deposit operation also needs to be rolled back. If not we will end up in a state where transferor loses money. Therefore, in order to ensure the atomicity (all or nothing property) we need to perform the money transfer operation as a transaction. 

This example explains three different scenarios where one user tries to transfer money from his/her account to another user's account. First scenario shows a successful transaction whereas the other to scenarios fail due to unique reasons. You can observe how transactions using Ballerina ensure the 'ACID' properties through this example.

## <a name="pre-req"></a> Prerequisites
 
- JDK 1.8 or later
- Ballerina Distribution (Install Instructions:  https://ballerinalang.org/docs/quick-tour/quick-tour/#install-ballerina)
- MySQL JDBC driver (Download https://dev.mysql.com/downloads/connector/j/)
  * Copy the downloaded JDBC driver to the <BALLERINA_HOME>/bre/lib folder 
- A Text Editor or an IDE 

Optional Requirements
- Docker (Follow instructions in https://docs.docker.com/engine/installation/)
- Ballerina IDE plugins. ( Intellij IDEA, VSCode, Atom)
- Testerina (Refer: https://github.com/ballerinalang/testerina)
- Container-support (Refer: https://github.com/ballerinalang/container-support)
- Docerina (Refer: https://github.com/ballerinalang/docerina)


## <a name="develop-app"></a> Developing the Application
### Before You Begin
##### Understand the Package Structure
Ballerina is a complete programming language that can have any custom project structure as you wish. Although language allows you to have any package structure, we'll stick with the following package structure for this project.

```
ManagingDatabaseTransactions
├── ballerina.conf
├── BankingApplication
│   ├── account-manager.bal
│   ├── account-manager_test.bal
│   ├── application.bal
│   └── dbUtil
│       ├── database-utilities.bal
│       └── database-utilities_test.bal
└── README.md

```
##### Add database configurations to the `ballerina.conf` file
The purpose of  `ballerina.conf` file is to provide any external configurations that are needed to ballerina programs. Since this guide have interact with MySQL database we need to provide the database connection properties to the ballerina program via `ballerina.cof` file.
This configuration file will have the following fields,
```
DATABASE_HOST = localhost
DATABASE_PORT = 3306
DATABASE_USERNAME = username
DATABASE_PASSWORD = password
DATABASE_NAME = bankDB
```
First you need to replace `localhost`, `3306`, `username`, `password` the respective MySQL database connection properties in the `ballerina.conf` file. You can keep the DATABASE_NAME as it is if you don't want to change the name explicitly.

# --------------- TODO ---------------

## Response You Will Get

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
