use master;
go

if exists(select * from sys.databases where name = 'AZBank')
begin
drop database AZBank;
end

go
create database AZBank;

go

use AZBank;

go

if object_id('Customer','u') is not null
begin 
drop table Customer;
end

go

create table Customer
(
	CustomerId int primary key not null,

	Name nvarchar (50) null,
	City nvarchar (50) null,
	Country nvarchar (50) null,
	Phone nvarchar (15) null,
	Email nvarchar (50) null,
)
go
if object_id('CustomerAccount','U') is not null
begin 
drop table CustomerAccount;
end

go

create table CustomerAccount(
	AccountNumber char(9) primary key not null,
	CustomerId int not null,
	Balance money not null,
	MinAccount money  null
	)

go

if object_id('CCustomerTransaction','U') is not null
begin 
drop table CustomerTransaction;
end

go

create table CustomerTransaction(
	TransectionTd int primary key not null,
	AccountNumber char(9) null,
	TransactionDate smalldatetime null,
	Amount money null,
	DepositorWithdraw bit null
)
go
	ALTER TABLE CustomerAccount
ADD CONSTRAINT FK_CustomerAccount_Customer
FOREIGN KEY (CustomerId)
REFERENCES Customer (CustomerId);
go
	ALTER TABLE CustomerTransaction ADD constraint FK_CustomerTransaction_CustomerAccount
	foreign key (AccountNumber) references CustomerAccount(AccountNumber);
	go
	insert into Customer(CustomerId,Name,City,Country,Phone,Email) values (1,'Thanh','Hanoi','VietNam','34384327772','thanh@gmail.com')
	insert into Customer(CustomerId,Name,City,Country,Phone,Email) values (2,'Thanh','Hanoi','VietNam','34384327772','thanh@gmail.com')
	insert into Customer(CustomerId,Name,City,Country,Phone,Email) values (3,'Thanh','Hanoi','VietNam','34384327772','thanh@gmail.com')

	go
	INSERT INTO CustomerAccount (AccountNumber, CustomerId, Balance, MinAccount) VALUES ('937412223', 1, 112223.00, 453534.44);
	INSERT INTO CustomerAccount (AccountNumber, CustomerId, Balance, MinAccount) VALUES ('937432422', 2, 11221.00, 453534.44);
	INSERT INTO CustomerAccount (AccountNumber, CustomerId, Balance, MinAccount) VALUES ('937434636', 3, 11222332.00, 453534.44);
	go
	insert into CustomerTransaction(TransectionTd,AccountNumber,TransactionDate,Amount,DepositorWithdraw) values (1,'937412223','1991-12-19 12:00:00',12123.22,1)
	insert into CustomerTransaction(TransectionTd,AccountNumber,TransactionDate,Amount,DepositorWithdraw) values (2,'937432422','12-2-2009 9:32:11',12123.22,0)
	insert into CustomerTransaction(TransectionTd,AccountNumber,TransactionDate,Amount,DepositorWithdraw) values (3,'937434636','9-1-2021 1:21:10',12123.22,1)
	go
	select * from Customer  where City ='Hanoi';
	go
	SELECT Customer.Name, Customer.Phone, Customer.Email, CustomerAccount.AccountNumber, CustomerAccount.Balance
	FROM Customer
	LEFT JOIN CustomerAccount ON Customer.CustomerId = CustomerAccount.CustomerId

	-- câu 6--
	ALTER TABLE CustomerTransaction
	ADD CONSTRAINT CHECK_Amount CHECK (Amount > 0 AND Amount <= 1000000);
	GO
	--câu 7--
	if OBJECT_ID('vCustomerTransactions','v') is not null
	begin
	drop view vCustomerTransactions
	end
	go

	CREATE VIEW vCustomerTransactions AS
	SELECT A.Name,B.AccountNumber,B.TransactionDate,B.Amount,B.DepositorWithdraw
	FROM Customer A
	INNER JOIN CustomerAccount C ON A.CustomerId = C.CustomerId
	INNER JOIN CustomerTransaction B ON C.AccountNumber = B.AccountNumber;
	GO
	SELECT * FROM vCustomerTransactions 
	
