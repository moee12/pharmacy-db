SET NOCOUNT ON;
GO

CREATE TABLE dbo.Category (
    CategoryID   INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE dbo.Medicine (
    MedicineID             INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID             INT NOT NULL,
    Name                   NVARCHAR(150) NOT NULL,
    Form                   NVARCHAR(50)  NOT NULL,      
    Strength               NVARCHAR(50)  NOT NULL,      
    PrescriptionRequired   BIT NOT NULL CONSTRAINT DF_Medicine_PrescriptionRequired DEFAULT (0),
    StockAlertThreshold    INT NOT NULL CONSTRAINT DF_Medicine_StockAlertThreshold DEFAULT (0),
    SellingPrice           DECIMAL(10,2) NOT NULL CONSTRAINT DF_Medicine_SellingPrice DEFAULT (0),

    CONSTRAINT FK_Medicine_Category
        FOREIGN KEY (CategoryID) REFERENCES dbo.Category(CategoryID),

    CONSTRAINT CK_Medicine_StockAlertThreshold
        CHECK (StockAlertThreshold >= 0),

    CONSTRAINT CK_Medicine_SellingPrice
        CHECK (SellingPrice >= 0)
);
GO

CREATE TABLE dbo.Supplier (
    SupplierID  INT IDENTITY(1,1) PRIMARY KEY,
    Name        NVARCHAR(150) NOT NULL UNIQUE,
    Contact     NVARCHAR(200) NULL
);
GO

CREATE TABLE dbo.Batch (
    BatchID        INT IDENTITY(1,1) PRIMARY KEY,
    MedicineID     INT NOT NULL,
    PurchaseID     INT NOT NULL,
    BatchNumber    NVARCHAR(60) NOT NULL,
    ExpiryDate     DATE NOT NULL,
    Quantity       INT NOT NULL,
    PurchasePrice  DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_Batch_Medicine
        FOREIGN KEY (MedicineID) REFERENCES dbo.Medicine(MedicineID),

    CONSTRAINT FK_Batch_Purchase
        FOREIGN KEY (PurchaseID) REFERENCES dbo.Purchase(PurchaseID),

    CONSTRAINT UQ_Batch_Medicine_BatchNumber
        UNIQUE (MedicineID, BatchNumber),

    CONSTRAINT CK_Batch_Quantity
        CHECK (Quantity >= 0),

    CONSTRAINT CK_Batch_PurchasePrice
        CHECK (PurchasePrice >= 0)
);
GO

CREATE TABLE dbo.Customer (
    CustomerID  INT IDENTITY(1,1) PRIMARY KEY,
    Name        NVARCHAR(150) NOT NULL,
    Phone       NVARCHAR(30)  NOT NULL UNIQUE,
    Location    NVARCHAR(150) NULL
);
GO

CREATE TABLE dbo.[User] (
    UserID  INT IDENTITY(1,1) PRIMARY KEY,
    Name    NVARCHAR(150) NOT NULL,
    Role    NVARCHAR(50)  NOT NULL
);
GO

CREATE TABLE dbo.Sale (
    SaleID        INT IDENTITY(1,1) PRIMARY KEY,
    UserID        INT NOT NULL,
    CustomerID    INT NULL,
    SaleDateTime  DATETIME2 NOT NULL CONSTRAINT DF_Sale_SaleDateTime DEFAULT (SYSDATETIME()),
    TotalPrice    DECIMAL(10,2) NOT NULL CONSTRAINT DF_Sale_TotalPrice DEFAULT (0),

    CONSTRAINT FK_Sale_User
        FOREIGN KEY (UserID) REFERENCES dbo.[User](UserID),

    CONSTRAINT FK_Sale_Customer
        FOREIGN KEY (CustomerID) REFERENCES dbo.Customer(CustomerID),

    CONSTRAINT CK_Sale_TotalPrice
        CHECK (TotalPrice >= 0)
);
GO

CREATE TABLE dbo.SaleItem (
    SaleItemID     INT IDENTITY(1,1) PRIMARY KEY,
    SaleID         INT NOT NULL,
    BatchID        INT NOT NULL,
    QuantitySold   INT NOT NULL,
    UnitPrice      DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_SaleItem_Sale
        FOREIGN KEY (SaleID) REFERENCES dbo.Sale(SaleID),

    CONSTRAINT FK_SaleItem_Batch
        FOREIGN KEY (BatchID) REFERENCES dbo.Batch(BatchID),

    CONSTRAINT CK_SaleItem_QuantitySold
        CHECK (QuantitySold > 0),

    CONSTRAINT CK_SaleItem_UnitPrice
        CHECK (UnitPrice >= 0)
);
GO