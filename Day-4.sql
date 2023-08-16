-- Create the database
CREATE DATABASE Assessmento4Db
USE Assessmento4Db

create table Products
(PId int primary key IDENTITY(500,1),
PName nvarchar(100) not null,
PPrice decimal(10,2),
PTax as PPrice * 0.10 PERSISTED,
PCompany nvarchar(50),
PQty int default 10 check(PQty >=1)
)

-- Insert records into the Products table 
INSERT INTO Products (PName, PPrice, PCompany, PQty)
VALUES
    ('Product 11', 110.00, 'Samsung', 5),
    ('Product 12', 210.00, 'Apple', 8),
    ('Product 13', 160.00, 'Redmi', 12),
    ('Product 14', 85.00, 'HTC', 15),
    ('Product 15', 320.00, 'RealMe', 20),
    ('Product 16', 270.00, 'Xiaomi', 7),
    ('Product 17', 130.00, 'Samsung', 9),
    ('Product 18', 190.00, 'Apple', 10),
    ('Product 19', 175.00, 'Redmi', 6),
    ('Product 20', 95.00, 'HTC', 3);

-- Create the first procedure to display product details
CREATE PROCEDURE usp_DisplayProductDetails
AS
BEGIN
    SELECT PId, PName, PPrice + PTax AS PPricewithTax, PCompany, PQty * (PPrice + PTax) AS TotalPrice
    FROM Products;
END;

alter proc usp_DisplayProductDetails
with encryption
as
select PId, PName, (PTax+PPrice) PriceWithTax, PCompany, (PQty*(PTax+PPrice)) as TotalPrice from Products

execute sp_helptext usp_DisplayProductDetails
exec usp_DisplayProductDetails

-- Create the second procedure to calculate total tax

create proc usp_getTotalTaxByCompany
@pCompany nvarchar(50),
@totalTax float output
with encryption
as
select @totalTax = SUM(PTax)
from Products
where PCompany = @pCompany

declare @totalTaxOutput float
exec usp_getTotalTaxByCompany
@pCompany = 'Redmi', @totalTax = @totalTaxOutput output;
print @totalTaxOutput

declare @totalTaxOutput float
exec usp_getTotalTaxByCompany
@pCompany = 'Samsung', @totalTax = @totalTaxOutput output;
print @totalTaxOutput

execute sp_helptext usp_getTotalTaxByCompany
