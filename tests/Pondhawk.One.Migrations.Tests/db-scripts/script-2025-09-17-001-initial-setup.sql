# ---------------------------------------------------------------------- #
# Script generated with: DeZign for Databases 14.6.5                     #
# Target DBMS:           MySQL 8                                         #
# Project file:          partner-connect.dez                             #
# Project name:          partner-connect                                 #
# Author:                                                                #
# Script type:           Database creation script                        #
# Created on:            2025-09-17 14:03                                #
# ---------------------------------------------------------------------- #


# ---------------------------------------------------------------------- #
# Add tables                                                             #
# ---------------------------------------------------------------------- #

# ---------------------------------------------------------------------- #
# Add table "Invoices"                                                   #
# ---------------------------------------------------------------------- #

CREATE TABLE `Invoices` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `LastUpdatedDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `TenantCode` VARCHAR(50) NOT NULL DEFAULT '',
    `ExternalInvoiceId` VARCHAR(50) NOT NULL DEFAULT '',
    `ExternalInvoiceDocNum` VARCHAR(50) NOT NULL DEFAULT '',
    `EngagementId` BIGINT NOT NULL,
    `ClientName` VARCHAR(100) NOT NULL DEFAULT '',
    `EngagementDescription` VARCHAR(100) NOT NULL DEFAULT '',
    `ResourceId` BIGINT NOT NULL,
    `DelivererName` VARCHAR(50) NOT NULL DEFAULT '',
    `BillingRequestId` BIGINT NOT NULL,
    `InvoiceDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `DueDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `InvoiceSentCode` VARCHAR(50) NOT NULL DEFAULT '',
    `Total` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `Balance` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `InvoiceUrl` VARCHAR(2048) NOT NULL DEFAULT '',
    `Voided` BOOL NOT NULL DEFAULT 0,
    `PaidStatusCode` VARCHAR(50) NOT NULL DEFAULT '',
    CONSTRAINT `PK_Invoices` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_Invoices_1` ON `Invoices` (`Uid`);

CREATE INDEX `IDX_Invoices_2` ON `Invoices` (`ExternalInvoiceId`);

CREATE INDEX `IDX_Invoices_3` ON `Invoices` (`EngagementId`);

# ---------------------------------------------------------------------- #
# Add table "InvoicePayments"                                            #
# ---------------------------------------------------------------------- #

CREATE TABLE `InvoicePayments` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `ExternalPaymentId` VARCHAR(50) NOT NULL DEFAULT '',
    `Amount` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `PaidDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    CONSTRAINT `PK_InvoicePayments` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_InvoicePayments_1` ON `InvoicePayments` (`ParentId`);

# ---------------------------------------------------------------------- #
# Add table "Bills"                                                      #
# ---------------------------------------------------------------------- #

CREATE TABLE `Bills` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `LastUpdatedDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `TenantCode` VARCHAR(50) NOT NULL DEFAULT '',
    `ExternalUserId` VARCHAR(50) NOT NULL DEFAULT '',
    `ExternalBillDocNum` VARCHAR(50) NOT NULL DEFAULT '',
    `ExternalBillId` VARCHAR(50) NOT NULL DEFAULT '',
    `ExternalInvoiceId` VARCHAR(50) NOT NULL DEFAULT '',
    `ExternalInvoiceDocNum` VARCHAR(50) NOT NULL DEFAULT '',
    `Description` VARCHAR(255) NOT NULL DEFAULT '',
    `ResourceId` BIGINT NOT NULL,
    `TrxDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `DueDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `CurrencyCode` VARCHAR(50) NOT NULL DEFAULT '',
    `InvoiceTotal` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ServicesTotal` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ExpensesTotal` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `SplitTotal` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `WithholdingTotal` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `CapitalTotal` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `Total` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `PaidDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `Balance` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ProcessCode` VARCHAR(50) NOT NULL DEFAULT '',
    `ErrorMessage` VARCHAR(4096) NOT NULL DEFAULT '',
    `Validated` BOOL NOT NULL DEFAULT 0,
    `ValidationResult` VARCHAR(2048) NOT NULL DEFAULT '',
    CONSTRAINT `PK_Bills` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_Bills_1` ON `Bills` (`Uid`);

# ---------------------------------------------------------------------- #
# Add table "BillLines"                                                  #
# ---------------------------------------------------------------------- #

CREATE TABLE `BillLines` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `ExternalAccountId` VARCHAR(25) NOT NULL DEFAULT '',
    `ExternalLineId` VARCHAR(25) NOT NULL DEFAULT '',
    `ExternalLineNum` VARCHAR(25) NOT NULL DEFAULT '',
    `TypeCode` VARCHAR(50) NOT NULL DEFAULT '',
    `Description` VARCHAR(255) NOT NULL DEFAULT '',
    `Amount` DECIMAL(20,2) NOT NULL DEFAULT 0,
    CONSTRAINT `PK_BillLines` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_BillLines_1` ON `BillLines` (`ParentId`);

# ---------------------------------------------------------------------- #
# Add table "Accounts"                                                   #
# ---------------------------------------------------------------------- #

CREATE TABLE `Accounts` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `TenantCode` VARCHAR(50) NOT NULL DEFAULT '',
    `ExternalAccountId` VARCHAR(50) NOT NULL DEFAULT '',
    `Active` BOOL NOT NULL DEFAULT 0,
    `Name` VARCHAR(255) NOT NULL DEFAULT '',
    `SubAccount` BOOL NOT NULL DEFAULT 0,
    `ParentRefId` VARCHAR(50) NOT NULL DEFAULT '',
    `ParentRefName` VARCHAR(255) NOT NULL DEFAULT '',
    `FullyQualifiedName` VARCHAR(255) NOT NULL DEFAULT '',
    `Description` VARCHAR(255) NOT NULL DEFAULT '',
    `Classification` VARCHAR(50) NOT NULL DEFAULT '',
    `AccountType` VARCHAR(100) NOT NULL DEFAULT '',
    `AccountSubType` VARCHAR(100) NOT NULL DEFAULT '',
    `AcctNum` VARCHAR(100) NOT NULL DEFAULT '',
    `OpeningBalance` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `OpeningBalanceDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `CurrentBalance` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `CurrentBalanceWithSubAccounts` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `CurrencyRefId` VARCHAR(50) NOT NULL DEFAULT '',
    `CurrencyRefName` VARCHAR(100) NOT NULL DEFAULT '',
    CONSTRAINT `PK_Accounts` PRIMARY KEY (`Id`)
);

# ---------------------------------------------------------------------- #
# Add table "InvoiceLines"                                               #
# ---------------------------------------------------------------------- #

CREATE TABLE `InvoiceLines` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `LineTypeCode` VARCHAR(50) NOT NULL DEFAULT '',
    `Description` VARCHAR(4096) NOT NULL DEFAULT '',
    `AttachmentKey` VARCHAR(255) NOT NULL DEFAULT '',
    `AttachmentName` VARCHAR(255) NOT NULL DEFAULT '',
    `Amount` DECIMAL(20,2) NOT NULL DEFAULT 0,
    CONSTRAINT `PK_InvoiceLines` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_InvoiceLines_1` ON `InvoiceLines` (`ParentId`);

# ---------------------------------------------------------------------- #
# Add table "BillingRequestTemplates"                                    #
# ---------------------------------------------------------------------- #

CREATE TABLE `BillingRequestTemplates` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `CreateTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `LastUpdatedTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `Active` BOOL NOT NULL DEFAULT 1,
    `Description` VARCHAR(255) NOT NULL DEFAULT '',
    `Notes` VARCHAR(4096) NOT NULL DEFAULT '',
    `EngagementId` BIGINT NOT NULL,
    `ResourceId` BIGINT NOT NULL,
    `ServicesDescription` VARCHAR(4096) NOT NULL DEFAULT '',
    `ServicesAmount` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ReadyToInvoice` BOOL NOT NULL DEFAULT 1,
    `FrequencyCode` VARCHAR(50) NOT NULL DEFAULT '',
    `FrequencyExpression` VARCHAR(100) NOT NULL DEFAULT '',
    `PeriodThruCode` VARCHAR(50) NOT NULL DEFAULT '',
    `PeriodThruExpression` VARCHAR(100) NOT NULL DEFAULT '',
    `LastGenerationDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `NextGenerationDate` DATETIME NOT NULL DEFAULT '2200-01-01 00:00:00',
    CONSTRAINT `PK_BillingRequestTemplates` PRIMARY KEY (`Id`)
);

# ---------------------------------------------------------------------- #
# Add table "BillingRequestAttachments"                                  #
# ---------------------------------------------------------------------- #

CREATE TABLE `BillingRequestAttachments` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `AttachmentKey` VARCHAR(255) NOT NULL DEFAULT '',
    `AttachmentName` VARCHAR(255) NOT NULL DEFAULT '',
    `Size` INTEGER NOT NULL,
    CONSTRAINT `PK_BillingRequestAttachments` PRIMARY KEY (`Id`)
);

# ---------------------------------------------------------------------- #
# Add table "InvoiceActivity"                                            #
# ---------------------------------------------------------------------- #

CREATE TABLE `InvoiceActivity` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `OccurredDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `ActivityCode` VARCHAR(50) NOT NULL DEFAULT '',
    `Description` VARCHAR(255) NOT NULL DEFAULT '',
    `Note` VARCHAR(2048) NOT NULL DEFAULT '',
    CONSTRAINT `PK_InvoiceActivity` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_InvoiceActivity_1` ON `InvoiceActivity` (`ParentId`);

# ---------------------------------------------------------------------- #
# Add table "InvoiceResources"                                           #
# ---------------------------------------------------------------------- #

CREATE TABLE `InvoiceResources` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `RoleCode` VARCHAR(50) NOT NULL DEFAULT '',
    `ResourceId` BIGINT NOT NULL,
    `ResourceName` VARCHAR(100) NOT NULL DEFAULT '',
    `AllocateFromCode` VARCHAR(50) NOT NULL DEFAULT '',
    `AllocationPercentage` DECIMAL(20,4) NOT NULL,
    `BillId` BIGINT,
    CONSTRAINT `PK_InvoiceResources` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_InvoiceResources_1` ON `InvoiceResources` (`ParentId`);

# ---------------------------------------------------------------------- #
# Add table "InvoiceAttachments"                                         #
# ---------------------------------------------------------------------- #

CREATE TABLE `InvoiceAttachments` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `AttachmentKey` VARCHAR(255) NOT NULL DEFAULT '',
    `AttachmentName` VARCHAR(255) NOT NULL DEFAULT '',
    CONSTRAINT `PK_InvoiceAttachments` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_InvoiceAttachments_1` ON `InvoiceAttachments` (`ParentId`);

# ---------------------------------------------------------------------- #
# Add table "BillPayments"                                               #
# ---------------------------------------------------------------------- #

CREATE TABLE `BillPayments` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `LastUpdatedDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `TenantCode` VARCHAR(50) NOT NULL DEFAULT '',
    `ExternalBillPaymentId` VARCHAR(50) NOT NULL DEFAULT '',
    `ResourceId` BIGINT NOT NULL,
    `Description` VARCHAR(255) NOT NULL DEFAULT '',
    `TrxDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `CurrencyCode` VARCHAR(50) NOT NULL DEFAULT '',
    `Total` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `NotificationSent` BOOL NOT NULL DEFAULT 0,
    `LastNotificationSent` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    CONSTRAINT `PK_BillPayments` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_BillPayments_1` ON `BillPayments` (`Uid`);

# ---------------------------------------------------------------------- #
# Add table "BillPaymentLines"                                           #
# ---------------------------------------------------------------------- #

CREATE TABLE `BillPaymentLines` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `BillId` BIGINT,
    `Amount` DECIMAL(20,2) NOT NULL DEFAULT 0,
    CONSTRAINT `PK_BillPaymentLines` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_BillPaymentLines_1` ON `BillPaymentLines` (`ParentId`);

# ---------------------------------------------------------------------- #
# Add table "BillingRequestLocations"                                    #
# ---------------------------------------------------------------------- #

CREATE TABLE `BillingRequestLocations` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `IsDefault` BOOL NOT NULL DEFAULT 0,
    `ZipCode` VARCHAR(25) NOT NULL DEFAULT '',
    `City` VARCHAR(100) NOT NULL DEFAULT '',
    `State` VARCHAR(25) NOT NULL DEFAULT '',
    `County` VARCHAR(100) NOT NULL DEFAULT '',
    `Country` VARCHAR(100) NOT NULL DEFAULT '',
    `Description` VARCHAR(255) NOT NULL DEFAULT '',
    `AllocationPercentage` DECIMAL(20,4) NOT NULL,
    CONSTRAINT `PK_BillingRequestLocations` PRIMARY KEY (`Id`)
);

# ---------------------------------------------------------------------- #
# Add table "IndustryCodes"                                              #
# ---------------------------------------------------------------------- #

CREATE TABLE `IndustryCodes` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `Code` VARCHAR(50) NOT NULL DEFAULT '',
    `Title` VARCHAR(255) NOT NULL DEFAULT '',
    `Description` VARCHAR(4096) NOT NULL DEFAULT '',
    CONSTRAINT `PK_IndustryCodes` PRIMARY KEY (`Id`)
);

# ---------------------------------------------------------------------- #
# Add table "UserIndustries"                                             #
# ---------------------------------------------------------------------- #

CREATE TABLE `UserIndustries` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `Code` VARCHAR(50) NOT NULL DEFAULT '',
    `Title` VARCHAR(255) NOT NULL DEFAULT '',
    `LevelCode` VARCHAR(50) NOT NULL DEFAULT '',
    CONSTRAINT `PK_UserIndustries` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_UserIndustries_1` ON `UserIndustries` (`ParentId`);

# ---------------------------------------------------------------------- #
# Add table "ZipCodes"                                                   #
# ---------------------------------------------------------------------- #

CREATE TABLE `ZipCodes` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(25) NOT NULL DEFAULT '',
    `Zip` CHAR(5) NOT NULL,
    `City` VARCHAR(35) NOT NULL,
    `State` CHAR(2) NOT NULL,
    `County` VARCHAR(45) NOT NULL,
    `AreaCode` VARCHAR(55) NOT NULL,
    `CityType` CHAR(1) NOT NULL,
    `CityAliasAbbreviation` VARCHAR(13) NOT NULL,
    `CityAliasName` VARCHAR(35) NOT NULL,
    `Latitude` DECIMAL(12,6) NOT NULL,
    `Longitude` DECIMAL(12,6) NOT NULL,
    `TimeZone` CHAR(2) NOT NULL,
    `Elevation` INTEGER NOT NULL,
    `CountyFIPS` CHAR(5) NOT NULL,
    `DayLightSaving` CHAR(1) NOT NULL,
    `PreferredLastLineKey` VARCHAR(10) NOT NULL,
    `ClassificationCode` CHAR(1) NOT NULL,
    `MultiCounty` CHAR(1) NOT NULL,
    `StateFIPS` CHAR(2) NOT NULL,
    `CityStateKey` CHAR(6) NOT NULL,
    `CityAliasCode` VARCHAR(5) NOT NULL,
    `PrimaryRecord` CHAR(1) NOT NULL,
    `CityMixedCase` VARCHAR(35) NOT NULL,
    `CityAliasMixedCase` VARCHAR(35) NOT NULL,
    `StateANSI` VARCHAR(2) NOT NULL,
    `CountyANSI` VARCHAR(3) NOT NULL,
    `FacilityCode` VARCHAR(1) NOT NULL,
    `CityDeliveryIndicator` VARCHAR(1) NOT NULL,
    `CarrierRouteRateSortation` VARCHAR(1) NOT NULL,
    `FinanceNumber` VARCHAR(6) NOT NULL,
    `UniqueZIPName` VARCHAR(1) NOT NULL,
    `CountyMixedCase` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`Id`)
)
 ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX `Index_ZipCodes_ZipCode` ON `ZipCodes` (`Zip`);

CREATE INDEX `Index_ZipCodes_State` ON `ZipCodes` (`State`);

CREATE INDEX `Index_ZipCodes_County` ON `ZipCodes` (`County`);

CREATE INDEX `Index_ZipCodes_AreaCode` ON `ZipCodes` (`AreaCode`);

CREATE INDEX `Index_ZipCodes_City` ON `ZipCodes` (`City`);

CREATE INDEX `Index_ZipCodes_Latitude` ON `ZipCodes` (`Latitude`);

CREATE INDEX `Index_ZipCodes_Longitude` ON `ZipCodes` (`Longitude`);

CREATE INDEX `Index_ZipCodes_CityAliasName` ON `ZipCodes` (`CityAliasName`);

CREATE INDEX `Index_ZipCodes_CityStateKey` ON `ZipCodes` (`CityStateKey`);

# ---------------------------------------------------------------------- #
# Add table "ZipCodeMins"                                                #
# ---------------------------------------------------------------------- #

CREATE TABLE `ZipCodeMins` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `Zip` VARCHAR(25) NOT NULL DEFAULT '',
    `City` VARCHAR(50) NOT NULL DEFAULT '',
    `State` VARCHAR(25) NOT NULL DEFAULT '',
    `County` VARCHAR(50) NOT NULL DEFAULT '',
    `AreaCode` VARCHAR(100) NOT NULL DEFAULT '',
    `Latitude` DECIMAL(12,6) NOT NULL,
    `Longitude` DECIMAL(12,6) NOT NULL,
    `Elevation` INTEGER NOT NULL,
    `TimeZone` VARCHAR(25) NOT NULL DEFAULT '',
    `DayLightSaving` VARCHAR(25) NOT NULL DEFAULT '',
    CONSTRAINT `PK_ZipCodeMins` PRIMARY KEY (`Id`)
);

# ---------------------------------------------------------------------- #
# Add table "Companies"                                                  #
# ---------------------------------------------------------------------- #

CREATE TABLE `Companies` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `CreateTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `LastUpdatedTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `Source` VARCHAR(100) NOT NULL DEFAULT '',
    `SourceUid` VARCHAR(100) NOT NULL DEFAULT '',
    `Name` VARCHAR(100) NOT NULL DEFAULT '',
    `LegalName` VARCHAR(100) NOT NULL DEFAULT '',
    `Description` VARCHAR(255) NOT NULL DEFAULT '',
    `Domain` VARCHAR(100) NOT NULL DEFAULT '',
    `Sector` VARCHAR(100) NOT NULL DEFAULT '',
    `IndustryGroup` VARCHAR(100) NOT NULL DEFAULT '',
    `Industry` VARCHAR(100) NOT NULL DEFAULT '',
    `SubIndustry` VARCHAR(100) NOT NULL DEFAULT '',
    `SicCode` VARCHAR(50) NOT NULL DEFAULT '',
    `NaicsCode` VARCHAR(50) NOT NULL DEFAULT '',
    `YearFounded` VARCHAR(25) NOT NULL DEFAULT '',
    `Location` VARCHAR(100) NOT NULL DEFAULT '',
    `TimeZone` VARCHAR(50) NOT NULL DEFAULT '',
    `UtcOffset` INTEGER NOT NULL,
    `StreetNumber` VARCHAR(25) NOT NULL DEFAULT '',
    `StreetName` VARCHAR(100) NOT NULL DEFAULT '',
    `SubPremise` VARCHAR(100) NOT NULL DEFAULT '',
    `City` VARCHAR(50) NOT NULL DEFAULT '',
    `State` VARCHAR(50) NOT NULL DEFAULT '',
    `StateCode` VARCHAR(25) NOT NULL DEFAULT '',
    `PostalCode` VARCHAR(25) NOT NULL DEFAULT '',
    `Country` VARCHAR(50) NOT NULL DEFAULT '',
    `CountryCode` VARCHAR(25) NOT NULL DEFAULT '',
    `Latitude` DECIMAL(12,6) NOT NULL,
    `Longitude` DECIMAL(12,6) NOT NULL,
    `Logo` VARCHAR(255) NOT NULL DEFAULT '',
    `CompanyType` VARCHAR(50) NOT NULL DEFAULT '',
    `Ticker` VARCHAR(25) NOT NULL DEFAULT '',
    `Ein` VARCHAR(25) NOT NULL DEFAULT '',
    `Phone` VARCHAR(25) NOT NULL DEFAULT '',
    `IndexDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `AlexaUsRank` VARCHAR(25) NOT NULL DEFAULT '',
    `AlexaGlobalRank` VARCHAR(25) NOT NULL DEFAULT '',
    `EmployeeCount` INTEGER NOT NULL,
    `EmployeesRange` VARCHAR(50) NOT NULL DEFAULT '',
    `MarketCap` VARCHAR(25) NOT NULL DEFAULT '',
    `CapitalRaised` VARCHAR(25) NOT NULL DEFAULT '',
    `AnnualRevenue` VARCHAR(25) NOT NULL DEFAULT '',
    `EstimatedAnnualRevenue` VARCHAR(50) NOT NULL DEFAULT '',
    `FiscalYearEnd` VARCHAR(25) NOT NULL DEFAULT '',
    `CompanyParent` VARCHAR(255) NOT NULL DEFAULT '',
    `UltimateCompanyParent` VARCHAR(255) NOT NULL DEFAULT '',
    CONSTRAINT `PK_Companies` PRIMARY KEY (`Id`)
);

# ---------------------------------------------------------------------- #
# Add table "CompanyKeywords"                                            #
# ---------------------------------------------------------------------- #

CREATE TABLE `CompanyKeywords` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `GroupName` VARCHAR(100) NOT NULL DEFAULT '',
    `Keywords` VARCHAR(8192) NOT NULL DEFAULT '',
    CONSTRAINT `PK_CompanyKeywords` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_CompanyKeywords_1` ON `CompanyKeywords` (`ParentId`);

# ---------------------------------------------------------------------- #
# Add table "UserCompanies"                                              #
# ---------------------------------------------------------------------- #

CREATE TABLE `UserCompanies` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `CompanyId` BIGINT NOT NULL,
    `CompanyName` VARCHAR(100) NOT NULL DEFAULT '',
    `WorkRelationshipCode` VARCHAR(50) NOT NULL DEFAULT '',
    `RoleCode` VARCHAR(50) NOT NULL DEFAULT '',
    `TechBudgetRangeCode` VARCHAR(50) NOT NULL DEFAULT '',
    `TechnologyBudget` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `Comments` VARCHAR(4096) NOT NULL DEFAULT '',
    `LevelCode` VARCHAR(50) NOT NULL DEFAULT '',
    CONSTRAINT `PK_UserCompanies` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_UserCompanies_1` ON `UserCompanies` (`ParentId`);

CREATE INDEX `IDX_UserCompanies_2` ON `UserCompanies` (`CompanyId`);

# ---------------------------------------------------------------------- #
# Add table "Payments"                                                   #
# ---------------------------------------------------------------------- #

CREATE TABLE `Payments` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `LastUpdatedDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `TenantCode` VARCHAR(50) NOT NULL DEFAULT '',
    `ExternalPaymentId` VARCHAR(25) NOT NULL DEFAULT '',
    `ExternalInvoiceId` VARCHAR(100) NOT NULL DEFAULT '',
    `TransactionDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `CurrencyCode` VARCHAR(50) NOT NULL DEFAULT '',
    `Total` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `Unapplied` DECIMAL(20,2) NOT NULL DEFAULT 0,
    CONSTRAINT `PK_Payments` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_Payments_1` ON `Payments` (`Uid`);

# ---------------------------------------------------------------------- #
# Add table "PaymentLines"                                               #
# ---------------------------------------------------------------------- #

CREATE TABLE `PaymentLines` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `TypeCode` VARCHAR(50) NOT NULL DEFAULT '',
    `ExternalAppliedId` VARCHAR(25) NOT NULL DEFAULT '',
    `Amount` DECIMAL(20,2) NOT NULL DEFAULT 0,
    CONSTRAINT `PK_PaymentLines` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_PaymentLines_1` ON `PaymentLines` (`ParentId`);

# ---------------------------------------------------------------------- #
# Add table "UserBadges"                                                 #
# ---------------------------------------------------------------------- #

CREATE TABLE `UserBadges` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `Description` VARCHAR(100) NOT NULL DEFAULT '',
    `Label` VARCHAR(25) NOT NULL DEFAULT '',
    `Color` VARCHAR(25) NOT NULL DEFAULT '',
    `Expiration` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    PRIMARY KEY (`Id`)
);

# ---------------------------------------------------------------------- #
# Add table "EngagementForecastHistory"                                  #
# ---------------------------------------------------------------------- #

CREATE TABLE `EngagementForecastHistory` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `SourceDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `Year` INTEGER NOT NULL DEFAULT 0,
    `Month` INTEGER NOT NULL DEFAULT 0,
    `ForecastMonth1` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth2` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth3` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth4` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth5` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth6` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth7` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth8` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth9` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth10` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth11` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth12` DECIMAL(20,2) NOT NULL DEFAULT 0,
    CONSTRAINT `PK_EngagementForecastHistory` PRIMARY KEY (`Id`)
);

# ---------------------------------------------------------------------- #
# Add table "UserSkills"                                                 #
# ---------------------------------------------------------------------- #

CREATE TABLE `UserSkills` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `LevelCode` VARCHAR(50) NOT NULL DEFAULT '',
    `Keywords` VARCHAR(2048) NOT NULL DEFAULT '',
    CONSTRAINT `PK_UserSkills` PRIMARY KEY (`Id`)
);

# ---------------------------------------------------------------------- #
# Add table "UserAttachments"                                            #
# ---------------------------------------------------------------------- #

CREATE TABLE `UserAttachments` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `AttachmentKey` VARCHAR(255) NOT NULL DEFAULT '',
    `AttachmentName` VARCHAR(255) NOT NULL DEFAULT '',
    `Size` INTEGER NOT NULL,
    CONSTRAINT `PK_UserAttachments` PRIMARY KEY (`Id`)
);

# ---------------------------------------------------------------------- #
# Add table "Vendors"                                                    #
# ---------------------------------------------------------------------- #

CREATE TABLE `Vendors` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `CompanyId` BIGINT NOT NULL,
    `CategoryCode` VARCHAR(50) NOT NULL DEFAULT '',
    `Offering` VARCHAR(100) NOT NULL DEFAULT '',
    `Description` VARCHAR(255) NOT NULL DEFAULT '',
    CONSTRAINT `PK_Vendors` PRIMARY KEY (`Id`)
);

# ---------------------------------------------------------------------- #
# Add table "VendorReviews"                                              #
# ---------------------------------------------------------------------- #

CREATE TABLE `VendorReviews` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `CreateTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `LastUpdatedTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `ParentId` BIGINT NOT NULL,
    `UserId` BIGINT NOT NULL,
    `Rating` INTEGER NOT NULL,
    `Review` VARCHAR(4096) NOT NULL DEFAULT '',
    CONSTRAINT `PK_VendorReviews` PRIMARY KEY (`Id`)
);

# ---------------------------------------------------------------------- #
# Add table "UserExternals"                                              #
# ---------------------------------------------------------------------- #

CREATE TABLE `UserExternals` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `ParentId` BIGINT NOT NULL,
    `TenantCode` VARCHAR(50) NOT NULL DEFAULT '',
    `ExternalUserId` VARCHAR(100) NOT NULL DEFAULT '',
    `WithholdingExempt` BOOL NOT NULL DEFAULT 0,
    `WithholdingAccountId` VARCHAR(100) NOT NULL DEFAULT '',
    `NoteAccountId` VARCHAR(2048) NOT NULL DEFAULT '',
    CONSTRAINT `PK_UserExternals` PRIMARY KEY (`Id`)
);

# ---------------------------------------------------------------------- #
# Add table "BillingRequests"                                            #
# ---------------------------------------------------------------------- #

CREATE TABLE `BillingRequests` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `CreateTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `LastUpdatedTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `LegBillingRequestId` INTEGER NOT NULL DEFAULT 0,
    `TemplateUid` VARCHAR(28) NOT NULL DEFAULT '',
    `EngagementId` BIGINT NOT NULL,
    `ResourceId` BIGINT NOT NULL,
    `PeriodThru` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `ServicesDescription` VARCHAR(4096) NOT NULL DEFAULT '',
    `ServicesAmount` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ServicesAttachmentName` VARCHAR(255) NOT NULL DEFAULT '',
    `ServicesAttachmentKey` VARCHAR(255) NOT NULL DEFAULT '',
    `ExpensesDescription` VARCHAR(4096) NOT NULL DEFAULT '',
    `ExpensesAmount` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ExpensesAttachmentName` VARCHAR(255) NOT NULL DEFAULT '',
    `ExpensesAttachmentKey` VARCHAR(255) NOT NULL DEFAULT '',
    `IsLastBillingRequest` BOOL NOT NULL DEFAULT 0,
    `ReadyToInvoice` BOOL NOT NULL DEFAULT 0,
    `ProcessCode` VARCHAR(50) NOT NULL DEFAULT '',
    `ProcessMessage` VARCHAR(4096) NOT NULL DEFAULT '',
    `ExternalInvoiceId` VARCHAR(50) NOT NULL DEFAULT '',
    `ExternalInvoiceDocNum` VARCHAR(50) NOT NULL DEFAULT '',
    `InvoiceDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `PaidDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    CONSTRAINT `PK_BillingRequests` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_BillingRequests_1` ON `BillingRequests` (`EngagementId`);

CREATE INDEX `IDX_BillingRequests_2` ON `BillingRequests` (`ResourceId`);

CREATE INDEX `IDX_BillingRequests_3` ON `BillingRequests` (`Uid`);

# ---------------------------------------------------------------------- #
# Add table "TenantSettings"                                             #
# ---------------------------------------------------------------------- #

CREATE TABLE `TenantSettings` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `TenantCode` VARCHAR(50) NOT NULL DEFAULT '',
    `DeliveryAccount` VARCHAR(100) NOT NULL DEFAULT '',
    `DealMpAccount` VARCHAR(100) NOT NULL DEFAULT '',
    `HomeMpAccount` VARCHAR(100) NOT NULL DEFAULT '',
    `PracticeLeaderMpAccount` VARCHAR(100) NOT NULL DEFAULT '',
    `ReferralAccount` VARCHAR(100) NOT NULL DEFAULT '',
    `GeneralPartnerAccount` VARCHAR(100) NOT NULL DEFAULT '',
    `ExpenseAccount` VARCHAR(100) NOT NULL DEFAULT '',
    CONSTRAINT `PK_TenantSettings` PRIMARY KEY (`Id`)
);

# ---------------------------------------------------------------------- #
# Add table "AuditJournals"                                              #
# ---------------------------------------------------------------------- #

CREATE TABLE `AuditJournals` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `UnitOfWorkUid` VARCHAR(255) NOT NULL DEFAULT '',
    `SubjectUid` VARCHAR(255) NOT NULL DEFAULT '',
    `SubjectDescription` VARCHAR(255) NOT NULL DEFAULT '',
    `Occurred` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `TypeCode` VARCHAR(255) NOT NULL DEFAULT '',
    `Entity` VARCHAR(255) NOT NULL DEFAULT '',
    `EntityUid` VARCHAR(255) NOT NULL DEFAULT '',
    `EntityDescription` VARCHAR(2048) NOT NULL DEFAULT '',
    `PropertyName` VARCHAR(255) NOT NULL DEFAULT '',
    `PreviousValue` VARCHAR(4096) NOT NULL DEFAULT '',
    `CurrentValue` VARCHAR(4096) NOT NULL DEFAULT '',
    CONSTRAINT `PK_AuditJournals` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_AuditJournals_1` ON `AuditJournals` (`Entity`,`EntityUid`);

# ---------------------------------------------------------------------- #
# Add table "Clients"                                                    #
# ---------------------------------------------------------------------- #

CREATE TABLE `Clients` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `TenantCode` VARCHAR(50) NOT NULL DEFAULT '',
    `ExternalClientId` VARCHAR(100) NOT NULL DEFAULT '',
    `ExternalSystemId` VARCHAR(100) NOT NULL DEFAULT '',
    `ExternalSystemSyncTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `CreateTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `LastUpdatedTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `Active` BOOL NOT NULL DEFAULT 1,
    `Name` VARCHAR(100) NOT NULL DEFAULT '',
    `Attention` VARCHAR(100) NOT NULL DEFAULT '',
    `Prefix` VARCHAR(25) NOT NULL DEFAULT '',
    `FirstName` VARCHAR(100) NOT NULL DEFAULT '',
    `MiddleName` VARCHAR(100) NOT NULL DEFAULT '',
    `LastName` VARCHAR(100) NOT NULL DEFAULT '',
    `Suffix` VARCHAR(25) NOT NULL DEFAULT '',
    `JobTitle` VARCHAR(100) NOT NULL DEFAULT '',
    `PrimaryPhone` VARCHAR(25) NOT NULL DEFAULT '',
    `SecondaryPhone` VARCHAR(25) NOT NULL DEFAULT '',
    `PrimaryEmail` VARCHAR(255) NOT NULL DEFAULT '',
    `SecondaryEmail` VARCHAR(255) NOT NULL DEFAULT '',
    `Address1` VARCHAR(255) NOT NULL DEFAULT '',
    `Address2` VARCHAR(255) NOT NULL DEFAULT '',
    `Address3` VARCHAR(255) NOT NULL DEFAULT '',
    `City` VARCHAR(50) NOT NULL DEFAULT '',
    `State` VARCHAR(25) NOT NULL DEFAULT '',
    `PostalCode` VARCHAR(25) NOT NULL DEFAULT '',
    `Country` VARCHAR(25) NOT NULL DEFAULT '',
    `Domain` VARCHAR(255) NOT NULL DEFAULT '',
    `CompanyId` BIGINT,
    `PaymentTermCode` VARCHAR(50) NOT NULL DEFAULT '',
    `Notes` VARCHAR(4096) NOT NULL DEFAULT '',
    `CurrencyCode` VARCHAR(50) NOT NULL DEFAULT '',
    `ClientBillingArrangement` VARCHAR(255) NOT NULL DEFAULT '',
    `ClientStory` TEXT,
    CONSTRAINT `PK_Clients` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_Clients_1` ON `Clients` (`Uid`);

# ---------------------------------------------------------------------- #
# Add table "Users"                                                      #
# ---------------------------------------------------------------------- #



CREATE TABLE `Users` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `TenantCode` VARCHAR(50) NOT NULL DEFAULT '',
    `ExternalUserId` VARCHAR(100) NOT NULL DEFAULT '',
    `ExternalSystemId` VARCHAR(100) NOT NULL DEFAULT '',
    `ExternalSystemSyncTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `Active` BOOL NOT NULL DEFAULT 1,
    `CreateTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `LastUpdatedTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `PartnerNumber` VARCHAR(25) NOT NULL DEFAULT '',
    `LeadershipRoleCode` VARCHAR(50) NOT NULL DEFAULT '',
    `PartnerStatusCode` VARCHAR(50) NOT NULL DEFAULT '',
    `ResourceTypeCode` VARCHAR(50) NOT NULL DEFAULT '',
    `DisplayName` VARCHAR(255) NOT NULL DEFAULT '',
    `Prefix` VARCHAR(25) NOT NULL DEFAULT '',
    `FirstName` VARCHAR(100) NOT NULL DEFAULT '',
    `MiddleName` VARCHAR(100) NOT NULL DEFAULT '',
    `LastName` VARCHAR(100) NOT NULL DEFAULT '',
    `Suffix` VARCHAR(25) NOT NULL DEFAULT '',
    `BirthDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `CompanyName` VARCHAR(100) NOT NULL DEFAULT '',
    `JobTitle` VARCHAR(100) NOT NULL DEFAULT '',
    `Address1` VARCHAR(255) NOT NULL DEFAULT '',
    `Address2` VARCHAR(255) NOT NULL DEFAULT '',
    `Address3` VARCHAR(255) NOT NULL DEFAULT '',
    `Attention` VARCHAR(100) NOT NULL DEFAULT '',
    `City` VARCHAR(50) NOT NULL DEFAULT '',
    `State` VARCHAR(25) NOT NULL DEFAULT '',
    `PostalCode` VARCHAR(25) NOT NULL DEFAULT '',
    `Country` VARCHAR(25) NOT NULL DEFAULT '',
    `AltAddress1` VARCHAR(100) NOT NULL DEFAULT '',
    `AltAddress2` VARCHAR(100) NOT NULL DEFAULT '',
    `AltCity` VARCHAR(50) NOT NULL DEFAULT '',
    `AltState` VARCHAR(25) NOT NULL DEFAULT '',
    `AltPostalCode` VARCHAR(25) NOT NULL DEFAULT '',
    `AltCountry` VARCHAR(25) NOT NULL DEFAULT '',
    `PrimaryEmail` VARCHAR(255) NOT NULL DEFAULT '',
    `PrimaryPhone` VARCHAR(25) NOT NULL DEFAULT '',
    `SecondaryEmail` VARCHAR(255) NOT NULL DEFAULT '',
    `SecondaryPhone` VARCHAR(25) NOT NULL DEFAULT '',
    `EmergencyContact` VARCHAR(100) NOT NULL DEFAULT '',
    `EmergencyContactPhone` VARCHAR(100) NOT NULL DEFAULT '',
    `EmergencyContactEmail` VARCHAR(100) NOT NULL DEFAULT '',
    `Notes` VARCHAR(4096) NOT NULL DEFAULT '',
    `Ssn` VARCHAR(25) NOT NULL DEFAULT '',
    `PhotoUrl` VARCHAR(2048) NOT NULL DEFAULT '',
    `LinkedInProfileUrl` VARCHAR(2048) NOT NULL DEFAULT '',
    `LanguagesSpoken` VARCHAR(255) NOT NULL DEFAULT '',
    `IsEntity` BOOL NOT NULL DEFAULT 0,
    `EntityTaxId` VARCHAR(25) NOT NULL DEFAULT '',
    `FederalTaxClassificationCode` VARCHAR(50) NOT NULL DEFAULT '',
    `TaxDocumentKey` VARCHAR(255) NOT NULL DEFAULT '',
    `SsnEncrypted` VARCHAR(255) NOT NULL DEFAULT '',
    `LegalName` VARCHAR(100) NOT NULL DEFAULT '',
    `SsnMask` VARCHAR(100) NOT NULL DEFAULT '',
    `EinEncrypted` VARCHAR(255) NOT NULL DEFAULT '',
    `EinMask` VARCHAR(100) NOT NULL DEFAULT '',
    `EquityAccountId` VARCHAR(25) NOT NULL DEFAULT '',
    `EntityTypeCode` VARCHAR(50) NOT NULL DEFAULT '',
    `EntityName` VARCHAR(100) NOT NULL DEFAULT '',
    `EntityAddress1` VARCHAR(100) NOT NULL DEFAULT '',
    `EntityAddress2` VARCHAR(100) NOT NULL DEFAULT '',
    `EntityCity` VARCHAR(50) NOT NULL DEFAULT '',
    `EntityState` VARCHAR(25) NOT NULL DEFAULT '',
    `EntityPostalCode` VARCHAR(25) NOT NULL DEFAULT '',
    `EntityCountry` VARCHAR(25) NOT NULL DEFAULT '',
    `EntityJoinedDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `TaxInfoId` VARCHAR(25) NOT NULL DEFAULT '',
    `NoteAccountId` VARCHAR(25) NOT NULL DEFAULT '',
    `WithholdingExempt` BOOL NOT NULL DEFAULT 0,
    `WithholdingAccountId` VARCHAR(25) NOT NULL DEFAULT '',
    `CapitalAccountId` VARCHAR(25) NOT NULL DEFAULT '',
    `CapitalAccountExempt` BOOL NOT NULL DEFAULT 0,
    `CapitalAccountBalance` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `UnitsOwned` INTEGER NOT NULL,
    `HomeAreaCode` VARCHAR(50) NOT NULL DEFAULT '',
    `HomeAmpId` BIGINT,
    `AdmissionDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `TermDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `PercentAvailable` DECIMAL(20,4) NOT NULL DEFAULT 0.00,
    `AvailabilityUpdated` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `AvailabilityNext30` DECIMAL(20,4) NOT NULL,
    `AvailabilityNext60` DECIMAL(20,4) NOT NULL,
    `AvailabilityNext90` DECIMAL(20,4) NOT NULL,
    `IdentityUid` VARCHAR(255) NOT NULL DEFAULT '',
    `WillingToTravel` BOOL NOT NULL DEFAULT 0,
    `MaximumTravelDays` INTEGER NOT NULL,
    `MaximumTravelDistance` INTEGER NOT NULL,
    `PaymentNetworkId` VARCHAR(100) NOT NULL DEFAULT '',
    `LastSecurityTrainingDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `InvoiceLock` BOOL NOT NULL DEFAULT 0,
    `InvoiceLockReason` VARCHAR(255) NOT NULL DEFAULT '',
    `IsResource` BOOL NOT NULL DEFAULT 0,
    `IsPartner` BOOL NOT NULL DEFAULT 0,
    `IsManager` BOOL NOT NULL DEFAULT 0,
    `IsAccounting` BOOL NOT NULL DEFAULT 0,
    `IsAdmin` BOOL NOT NULL DEFAULT 0,
    `DoNotSendToTerminated` BOOL NOT NULL DEFAULT 0,
    `ProfileNarrative` TEXT,
    `WorkExperienceNarrative` TEXT,
    `FunctionalSkillsNarrative` TEXT,
    `AvailabilityNarrative` TEXT,
    CONSTRAINT `PK_Users` PRIMARY KEY (`Id`)
);



# ---------------------------------------------------------------------- #
# Add table "Engagements"                                                #
# ---------------------------------------------------------------------- #

CREATE TABLE `Engagements` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `CreateTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `LastUpdatedTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `Active` BOOL NOT NULL DEFAULT 1,
    `ParentId` BIGINT NOT NULL,
    `Description` VARCHAR(100) NOT NULL DEFAULT '',
    `EngagementTypeCode` VARCHAR(50) NOT NULL DEFAULT '',
    `BillingArrangementCode` VARCHAR(50) NOT NULL DEFAULT '',
    `LeadershipRoleCode` VARCHAR(50) NOT NULL DEFAULT '',
    `PurchaseOrderNo` VARCHAR(255) NOT NULL DEFAULT '',
    `BillingRateCode` VARCHAR(50) NOT NULL DEFAULT '',
    `BillingRate` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `HubspotDealNo` VARCHAR(100) NOT NULL DEFAULT '',
    `AutomaticInvoicing` BOOL NOT NULL DEFAULT 0,
    `SendInvoiceReminders` BOOL NOT NULL DEFAULT 1,
    `LastInvoiceReminderSentDate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `ExternalEngagementId` VARCHAR(50) NOT NULL DEFAULT '',
    `ExternalEngagementSplitId` VARCHAR(50) NOT NULL DEFAULT '',
    `LocationSourceCode` VARCHAR(50) NOT NULL DEFAULT '',
    `DefaultLocationState` VARCHAR(25) NOT NULL DEFAULT '',
    `DefaultLocationZip` VARCHAR(25) NOT NULL DEFAULT '',
    `DefaultLocationDescription` VARCHAR(255) NOT NULL DEFAULT '',
    `RevenueOwnerId` BIGINT,
    `ForecastLastUpdate` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `ForecastMonth1` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth2` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth3` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth4` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth5` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth6` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth7` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth8` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth9` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth10` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth11` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ForecastMonth12` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `ChargeAdminFee` BOOL NOT NULL DEFAULT 0,
    `AdminFeeDescription` VARCHAR(100) NOT NULL DEFAULT '',
    `AdminFeeAmount` DECIMAL(20,2) NOT NULL DEFAULT 0,
    `PreEngagementChecklist` BOOL NOT NULL DEFAULT 0,
    `PostEngagementChecklist` BOOL NOT NULL DEFAULT 0,
    `EngagementStory` TEXT,
    CONSTRAINT `PK_Engagements` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_Engagements_1` ON `Engagements` (`ParentId`);

CREATE INDEX `IDX_Engagements_2` ON `Engagements` (`Uid`);

# ---------------------------------------------------------------------- #
# Add table "EngagementResources"                                        #
# ---------------------------------------------------------------------- #

CREATE TABLE `EngagementResources` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `CreateTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `LastUpdatedTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `ParentId` BIGINT NOT NULL,
    `RoleCode` VARCHAR(50) NOT NULL DEFAULT '',
    `ResourceId` BIGINT NOT NULL,
    `AllocateFromCode` VARCHAR(50) NOT NULL DEFAULT '',
    `AllocationPercentage` DECIMAL(20,4) NOT NULL,
    `IncludeOnInvoiceEmails` BOOL NOT NULL DEFAULT 1,
    CONSTRAINT `PK_EngagementResources` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_EngagementResources_1` ON `EngagementResources` (`ParentId`);

CREATE INDEX `IDX_EngagementResources_2` ON `EngagementResources` (`ResourceId`);

# ---------------------------------------------------------------------- #
# Add table "ClientContacts"                                             #
# ---------------------------------------------------------------------- #

CREATE TABLE `ClientContacts` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `CreateTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `LastUpdatedTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `ParentId` BIGINT NOT NULL,
    `DisplayName` VARCHAR(255) NOT NULL DEFAULT '',
    `Prefix` VARCHAR(25) NOT NULL DEFAULT '',
    `FirstName` VARCHAR(100) NOT NULL DEFAULT '',
    `MiddleName` VARCHAR(100) NOT NULL DEFAULT '',
    `LastName` VARCHAR(100) NOT NULL DEFAULT '',
    `Suffix` VARCHAR(25) NOT NULL DEFAULT '',
    `JobTitle` VARCHAR(100) NOT NULL DEFAULT '',
    `PrimaryBusinessContact` BOOL NOT NULL DEFAULT 0,
    `PrimaryEmail` VARCHAR(255) NOT NULL DEFAULT '',
    `PrimaryPhone` VARCHAR(25) NOT NULL DEFAULT '',
    `SecondaryEmail` VARCHAR(255) NOT NULL DEFAULT '',
    `SecondaryPhone` VARCHAR(25) NOT NULL DEFAULT '',
    CONSTRAINT `PK_ClientContacts` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_ClientContacts_1` ON `ClientContacts` (`ParentId`);

# ---------------------------------------------------------------------- #
# Add table "EngagementContacts"                                         #
# ---------------------------------------------------------------------- #

CREATE TABLE `EngagementContacts` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `CreateTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `LastUpdatedTime` DATETIME NOT NULL DEFAULT '1883-11-19 00:00:00',
    `ParentId` BIGINT NOT NULL,
    `ClientContactId` BIGINT NOT NULL,
    `IncludeOnInvoice` BOOL NOT NULL DEFAULT 0,
    `IncludeOnStatement` BOOL NOT NULL DEFAULT 0,
    `IncludeOnInvoiceReminder` BOOL NOT NULL DEFAULT 0,
    CONSTRAINT `PK_EngagementContacts` PRIMARY KEY (`Id`)
);

CREATE INDEX `IDX_EngagementContacts_1` ON `EngagementContacts` (`ParentId`);

CREATE INDEX `IDX_EngagementContacts_2` ON `EngagementContacts` (`ClientContactId`);

# ---------------------------------------------------------------------- #
# Add table "ReferenceCodes"                                             #
# ---------------------------------------------------------------------- #

CREATE TABLE `ReferenceCodes` (
    `Id` BIGINT NOT NULL AUTO_INCREMENT,
    `Uid` VARCHAR(28) NOT NULL DEFAULT '',
    `Active` BOOL NOT NULL DEFAULT 1,
    `GroupName` VARCHAR(100) NOT NULL DEFAULT '',
    `Code` VARCHAR(50) NOT NULL DEFAULT '',
    `Description` VARCHAR(255) NOT NULL DEFAULT '',
    `Data` VARCHAR(255) NOT NULL DEFAULT '',
    `DisplayOrder` VARCHAR(25) NOT NULL DEFAULT '',
    CONSTRAINT `PK_ReferenceCodes` PRIMARY KEY (`Id`)
);

# ---------------------------------------------------------------------- #
# Add views                                                              #
# ---------------------------------------------------------------------- #

CREATE VIEW `BillingRequestExplorers` AS

SELECT          
    b.Id, 
    b.Uid, 
    e.Uid AS EngagementUid,
    e.Description AS EngagementDescription,
    c.TenantCode,
    c.Uid AS ClientUid,
    c.Name AS ClientName,
    u.Uid AS ResourceUid,
    CONCAT(u.FirstName, ' ', u.LastName) AS ResourceName,
    b.PeriodThru, 
    b.ServicesDescription,
    b.ServicesAmount,
    b.ExpensesDescription,         
    b.ExpensesAmount, 
    b.ReadyToInvoice,         
    b.ProcessCode,
    b.ProcessMessage,
    b.InvoiceDate,      
    b.ExternalInvoiceId,
    b.ExternalInvoiceDocNum,           
    b.InvoiceDate > '1883-11-19 00:00:00' AS Invoiced,
    IF( b.InvoiceDate > '1883-11-19 00:00:00', CONVERT(YEAR(b.InvoiceDate),CHAR(4)),'') AS InvoiceYear,
    IF( b.InvoiceDate > '1883-11-19 00:00:00', CONVERT(MONTH(b.InvoiceDate),CHAR(2)),'') AS InvoiceMonth,
    b.PaidDate,
    COALESCE((SELECT CONCAT( ud.LastName,', ', ud.FirstName) FROM EngagementResources AS erd JOIN Users ud ON ud.Id = erd.ResourceId WHERE erd.ParentId = e.Id AND erd.RoleCode = 'Deal AMP' LIMIT 1)  ,'') AS DealAmp,    
    COALESCE((SELECT CONCAT( uh.LastName,', ', uh.FirstName) FROM EngagementResources AS erh JOIN Users uh ON uh.Id = erh.ResourceId WHERE erh.ParentId = e.Id AND erh.RoleCode = 'Home AMP' LIMIT 1)  ,'') AS HomeAmp,    
    COALESCE((SELECT CONCAT( ur.LastName,', ', ur.FirstName) FROM EngagementResources AS erh JOIN Users ur ON ur.Id = erh.ResourceId WHERE erh.ParentId = e.Id AND erh.RoleCode = 'Referral' LIMIT 1)  ,'') AS Referral,                                          
    (COALESCE((SELECT Balance FROM Invoices AS i WHERE i.ExternalInvoiceId = b.ExternalInvoiceId),1.00) = 0) AS `Paid`,
    COALESCE((SELECT Balance FROM Invoices AS i WHERE i.ExternalInvoiceId = b.ExternalInvoiceId),b.ServicesAmount+b.ExpensesAmount) AS `Balance`  
        
FROM BillingRequests AS b
JOIN Engagements AS e ON e.Id = b.EngagementId
JOIN Clients AS c ON c.Id = e.ParentId
JOIN Users AS u ON u.Id = b.ResourceId;

CREATE VIEW `ClientExplorers` AS
SELECT   
    c.`Id`,                  
    c.`Uid`,        
    c.`TenantCode`,         
    c.`CreateTime`,
    c.`LastUpdatedTime`,
    c.`Active`,
    c.`Name`,
    c.`Attention`,
    c.`Prefix`,
    c.`FirstName`,
    c.`MiddleName`,
    c.`LastName`,
    c.`Suffix`,
    c.`JobTitle`,
    c.`PrimaryPhone`,
    c.`PrimaryEmail`,
    c.`City`,
    c.`State`,
    c.`PostalCode`,
    c.`Country`,
    c.`Domain`,
    c.`PaymentTermCode`,
    c.`CurrencyCode`,
    c.`ClientBillingArrangement`,
    c.`ExternalClientId`,
    COALESCE((SELECT SUM( e.ForecastMonth1+e.ForecastMonth2+e.ForecastMonth3+e.ForecastMonth4+e.ForecastMonth5+e.ForecastMonth6+e.ForecastMonth7+e.ForecastMonth8+e.ForecastMonth9+e.ForecastMonth10+e.ForecastMonth11+e.ForecastMonth12) FROM Engagements AS e WHERE e.ParentId = c.Id AND e.Active = 1), 0.00)AS ForecastTotal,
    COALESCE(cm.Uid,'') AS CompanyUid,
    COALESCE(cm.Sector, '') AS Sector,
    COALESCE(cm.IndustryGroup, '') AS IndustryGroup,
    COALESCE(cm.Industry, '') AS Industry,
    COALESCE(cm.EmployeesRange, '') AS EmployeesRange,
    COALESCE(cm.EmployeeCount, '') AS EmployeeCount,    
    COALESCE(cm.EstimatedAnnualRevenue, '') AS AnnualRevenue,    
    (SELECT COUNT(*) FROM ClientContacts AS cc WHERE cc.ParentId = c.Id) AS ContactCount
FROM Clients c
LEFT OUTER JOIN Companies cm ON cm.Id = c.CompanyId;

CREATE VIEW `ResourceExplorers` AS
SELECT 
                                
    er.Id,
    er.Uid,
    c.Uid AS ClientUid,                      
    e.Uid AS EngagementUid,
    e.LocationSourceCode,
    e.DefaultLocationState,         
    e.DefaultLocationZip,     
    e.DefaultLocationDescription,    
    u.Uid AS ResourceUid,
    u.LeadershipRoleCode,
    'Resource Location' AS UserLocationDescription,
    u.State as UserLocationState,
    u.PostalCode AS UserLocationZip,  
    er.`RoleCode`,
    c.TenantCode,
    c.Name AS ClientName,        
    'Client Location' AS ClientLocationDescription,     
    c.State as ClientLocationState,    
    c.PostalCode AS ClientLocationZip, 
    e.`Description`,               
    u.`FirstName`,                   
    u.`LastName`,
    u.HomeAreaCode,
    u.InvoiceLock,
    u.InvoiceLockReason     

FROM EngagementResources AS er
JOIN Engagements AS e ON e.Id = er.`ParentId`
JOIN Clients AS c ON c.Id = e.ParentId
JOIN Users AS u ON u.Id = er.`ResourceId`

WHERE c.Active = 1 and e.`Active` = 1 AND er.`RoleCode` = 'Delivery';

CREATE VIEW `EngagementRefs` AS
SELECT

    e.Id,
    e.`Uid`,
    e.Active,
    e.LastUpdatedTime,
    e.Description,              
    e.ExternalEngagementId,          
    e.ExternalEngagementSplitId,       
    c.Id as ClientId,
    c.Uid as ClientUid,
    c.TenantCode,
    c.`Name` AS ClientName,
    c.ExternalClientId 

FROM Engagements AS e
JOIN Clients AS c ON c.Id = e.`ParentId`    ;

CREATE VIEW `UserExplorers` AS
SELECT             
          
  u.`Id`,
  u.`Uid`,
  u.`TenantCode`,
   COALESCE((SELECT ExternalUserId FROM UserExternals AS ue WHERE ue.ParentId = u.Id AND ue.TenantCode = 'US'),'') AS ExternalUserId,
  u.`ExternalSystemId`,
  u.`ExternalSystemSyncTime`,
  u.`Active`,
  u.`CreateTime`,
  u.`LastUpdatedTime`,
  u.`PartnerNumber`,
  u.`LeadershipRoleCode`,
  u.`PartnerStatusCode`,
  u.`ResourceTypeCode`,
  u.`DisplayName`,
  u.`Prefix`,
  u.`FirstName`,
  u.`MiddleName`,
  u.`LastName`,
  u.`Suffix`,
  u.`BirthDate`,
  u.`CompanyName`,
  u.`JobTitle`,
  u.`Address1`,
  u.`Address2`,
  u.`Address3`,
  u.`Attention`,
  u.`City`,
  u.`State`,
  u.`PostalCode`,
  u.`Country`,
  u.`AltAddress1`,
  u.`AltAddress2`,
  u.`AltCity`,
  u.`AltState`,
  u.`AltPostalCode`,
  u.`AltCountry`,
  u.`PrimaryEmail`,
  u.`PrimaryPhone`,
  u.`SecondaryEmail`,
  u.`SecondaryPhone`,
  u.`EmergencyContact`,
  u.`EmergencyContactPhone`,
  u.`EmergencyContactEmail`,
  u.`Notes`,
  u.`Ssn`,
  u.`PhotoUrl`,
  u.`LinkedInProfileUrl`,
  u.`LanguagesSpoken`,
  u.`IsEntity`,
  u.`EntityTaxId`,
  u.`FederalTaxClassificationCode`,
  u.`TaxDocumentKey`,
  u.`SsnEncrypted`,
  u.`LegalName`,
  u.`SsnMask`,
  u.`EinEncrypted`,
  u.`EinMask`,
  u.`EquityAccountId`,
  u.`TaxInfoId`,
  u.`EntityJoinedDate`,    
  u.`EntityTypeCode`,  
  u.`EntityName`,
  u.`EntityAddress1`,
  u.`EntityAddress2`,
  u.`EntityCity`,
  u.`EntityState`,
  u.`EntityPostalCode`,
  u.`EntityCountry`,
  u.`NoteAccountId`,
  u.`WithholdingExempt`,
  u.`WithholdingAccountId`,
  u.`CapitalAccountId`,
  u.`CapitalAccountExempt`,
  u.`CapitalAccountBalance`,
  u.`UnitsOwned`,
  u.`HomeAreaCode`,
  u.`HomeAmpId`,
  u.`AdmissionDate`,      
  u.`TermDate`,
  u.`PercentAvailable`,
  u.`AvailabilityUpdated`,
  u.`AvailabilityNext30`,
  u.`AvailabilityNext60`,
  u.`AvailabilityNext90`,
  u.`IdentityUid`,
  u.`WillingToTravel`,
  u.`MaximumTravelDays`,
  u.`MaximumTravelDistance`,
  u.`PaymentNetworkId`,
  u.`LastSecurityTrainingDate`,
  u.`InvoiceLock`,
  u.`InvoiceLockReason`,
  u.`IsResource`,
  u.`IsPartner`,
  u.`IsAccounting`,  
  u.`IsManager`,
  u.`IsAdmin`,
  DATEDIFF(NOW(),u.AvailabilityUpdated) AS AvailabilityOverdueDays,
  DATEDIFF(NOW(),u.LastSecurityTrainingDate) AS SecurityTrainingOverdueDays,    
  COALESCE((SELECT COUNT(*) FROM EngagementResources AS er JOIN Engagements AS e ON e.Id = er.ParentId WHERE e.Active = 1 AND er.ResourceId = u.Id AND er.RoleCode = 'Delivery'),0) AS EngagementCount,
  COALESCE((SELECT SUM( e.ForecastMonth1+e.ForecastMonth2+e.ForecastMonth3+e.ForecastMonth4+e.ForecastMonth5+e.ForecastMonth6+e.ForecastMonth7+e.ForecastMonth8+e.ForecastMonth9+e.ForecastMonth10+e.ForecastMonth11+e.ForecastMonth12) FROM EngagementResources AS er JOIN Engagements AS e ON e.Id = er.ParentId WHERE e.Active = 1 AND er.ResourceId = u.Id AND er.RoleCode = 'Delivery'), 0.00) AS ForecastTotal,    
  (SELECT COUNT(*) FROM UserCompanies AS uc WHERE uc.ParentId = u.Id) AS ExperienceCount    
FROM Users u                                                    ;

CREATE VIEW `UserRefs` AS
SELECT 

    u.`Id`,
    u.`Uid`,
    u.`TenantCode`,
    u.`Active`,
    u.`LeadershipRoleCode`,
    u.`ResourceTypeCode`,
    u.`DisplayName`,
    u.`FirstName`,
    u.`LastName`,
    u.`PrimaryEmail`,
    u.`HomeAreaCode`,
    u.`IsAdmin`,
    COALESCE((SELECT ExternalUserId FROM UserExternals AS ue WHERE ue.ParentId = u.Id AND ue.TenantCode = 'US'),'') AS ExternalUserId,
    u.`WithholdingAccountId`,
    u.`WithholdingExempt`,
    u.`NoteAccountId`,
    u.`CapitalAccountId`,
    u.`CapitalAccountExempt`,
    COALESCE((SELECT ue.ExternalUserId FROM UserExternals AS ue WHERE ue.ParentId = u.Id AND TenantCode = "US" LIMIT 1),'') AS USExternalUserId,
    COALESCE((SELECT ue.ExternalUserId FROM UserExternals AS ue WHERE ue.ParentId = u.Id AND TenantCode = "CA" LIMIT 1),'') AS CAExternalUserId    
    
FROM Users u;

CREATE VIEW `AutoBillingRequests` AS

SELECT 
    b.Id, 
    b.Uid, 
    e.Uid AS EngagementUid,
    e.Description AS EngagementDescription,
    c.Uid AS ClientUid,
    c.Name AS ClientName,
    c.ExternalClientId as ClientExternalId,
    u.Uid AS ResourceUid,
    CONCAT(u.FirstName, ' ', u.LastName) AS ResourceName,
    u.ExternalUserId as ResourceExternalId,
    b.PeriodThru, 
    b.ServicesDescription,
    b.ServicesAmount,
    b.ServicesAttachmentKey,
    b.ExpensesDescription,         
    b.ExpensesAmount, 
    b.ExpensesAttachmentKey,    
    b.ReadyToInvoice         
        
FROM BillingRequests AS b
JOIN Engagements AS e ON e.Id = b.EngagementId
JOIN Clients AS c ON c.Id = e.ParentId
JOIN Users AS u ON u.Id = b.ResourceId;

CREATE VIEW `BillingRequestTemplateExplorers` AS

SELECT

    brt.Id,                        
    brt.Uid,
    brt.Active,
    brt.LastUpdatedTime,
    brt.Description,
    e.Description AS EngagementDescription,
    CONCAT( u.FirstName, ' ', u.LastName ) AS ResourceName,
    brt.`ServicesDescription`,
    brt.ServicesAmount,
    brt.NextGenerationDate
    
FROM BillingRequestTemplates AS brt            
JOIN Engagements AS e ON e.Id = brt.EngagementId
JOIN Users AS u ON u.Id = brt.ResourceId
    ;

CREATE VIEW `InvoiceExplorers` AS
SELECT 
                                                
    i.Id,
    i.Uid,                       
    i.ExternalInvoiceId,        
    i.ExternalInvoiceDocNum,
    i.TenantCode,
    i.ClientName,                        
    i.EngagementDescription,
    u.Uid as ResourceUid,
    i.DelivererName,
    i.`InvoiceDate`,
    i.`DueDate`,               
    i.`Total`,
    i.`InvoiceSentCode`,
    i.`Balance`,                 
    i.`PaidStatusCode`,
    (CASE WHEN i.`Balance`> 0 THEN 0 ELSE 1 END) AS Paid,    
    (CASE WHEN i.`Balance`> 0 AND i.DueDate < NOW() THEN 1 ELSE 0 END) AS Overdue
    
FROM Invoices AS i            
join Users as u on u.Id = i.ResourceId;

CREATE VIEW `ClientActivity` AS

SELECT 
    
    ia.`Id`,
    ia.Uid AS Uid,
    i.`Id` AS InvoiceId,     
    i.Uid AS InvoiceUid,
    i.ExternalInvoiceId,
    i.ExternalInvoiceDocNum,
    i.`InvoiceDate`,
    i.`Total` AS InvoiceTotal,
    i.Balance AS InvoiceBalance,
    c.Id AS ClientId,
    c.Uid AS ClientUid,
    c.`Name`AS ClientName,
    e.Id AS EngagementId,
    e.Uid AS EngagementUid,
    e.`Description` AS EngagementDescription,
    u.`Id` AS ResourceId,
    u.Uid AS ResourceUid,
    u.`DisplayName` AS ResourceName,
    ia.`ActivityCode`,
    ia.`Description`,
    ia.`OccurredDate`,
    ia.Note

FROM InvoiceActivity ia
JOIN Invoices i ON i.Id = ia.`ParentId`
JOIN Engagements e ON e.Id = i.`EngagementId`
JOIN Users u ON u.Id = i.`ResourceId`
JOIN Clients c ON c.Id = e.`ParentId`;

CREATE VIEW `AvailabilityExplorers` AS

SELECT 
                   
    u.Id,               
    u.Uid,
    u.TenantCode,  
    u.Active,          
    u.PartnerStatusCode,
    u.FirstName,
    u.LastName,
    u.`PrimaryEmail`,
    u.`PrimaryPhone`,    
    u.`City`,                                             
    u.`State`,            
    u.`PostalCode`,                
    u.Country,
    u.LeadershipRoleCode,    
    u.ResourceTypeCode,
    u.PhotoUrl,   
    u.HomeAreaCode,
    COALESCE(u2.DisplayName,'') AS HomeAmp,
    u.`LanguagesSpoken`,
    u.`PercentAvailable`,
    u.`AvailabilityUpdated`,
    u.`AvailabilityNext30`,
    u.`AvailabilityNext60`,
    u.`AvailabilityNext90`,
    u.IsPartner,
    (SELECT COUNT(*) FROM EngagementResources AS er JOIN Engagements AS e ON e.Id = er.ParentId WHERE er.ResourceId = u.Id AND er.RoleCode = 'Delivery' AND e.Active = TRUE) AS ActiveEngagementCount

FROM Users AS u
LEFT JOIN Users u2 ON u2.Id = u.`HomeAmpId`;

CREATE VIEW `ZipCodeExplorers` AS

SELECT 

    z.Id,
    z.Uid,
    z.Zip,
    MAX(z.City) AS City,
    MAX(z.State) AS State,
    MAX(z.County) AS County,
    MAX(z.AreaCode) AS AreaCode,
    MAX(z.Latitude) AS Latitude,    
    MAX(z.Longitude) AS Longitude,    
    MAX(z.Elevation) AS Elevation,    
    MAX(z.TimeZone) AS TimeZone,        
    MAX(z.DayLightSaving) AS DayLightSaving        

FROM ZipCodes AS z
GROUP BY z.Zip;

CREATE VIEW `UserWorkExperiences` AS

SELECT                    
                 
    uc.Id,               
    uc.Uid,         
    u.Id AS UserId,
    TRUE AS Prior,
    FALSE as Active,
    c.Id AS CompanyId,
    c.Name,
    c.Domain,
    c.Description,
    c.Location,
    c.Logo,
    c.Sector,
    c.IndustryGroup,
    c.Industry,
    c.SubIndustry,
    uc.`WorkRelationshipCode`,   
    uc.`RoleCode`,         
    uc.`TechBudgetRangeCode`,
    uc.Comments,
    COALESCE((SELECT Keywords FROM CompanyKeywords AS ck WHERE ck.ParentId = c.Id AND GroupName = 'Tags'),'') AS Tags,
    COALESCE((SELECT Keywords FROM CompanyKeywords AS ck WHERE ck.ParentId = c.Id AND GroupName = 'TechCategories'),'') AS TechCategories,    
    COALESCE((SELECT Keywords FROM CompanyKeywords AS ck WHERE ck.ParentId = c.Id AND GroupName = 'Tech'),'') AS Tech        

FROM UserCompanies AS uc
JOIN Users AS u ON u.Id = uc.ParentId
JOIN Companies AS c ON c.Id = uc.CompanyId

                                             
UNION DISTINCT

SELECT     
                 
    er.Id+5000000000000 AS Id,               
    er.Uid AS Uid,            
    u.Id AS UserId,
    FALSE AS Prior,
    e.Active,
    c.Id AS CompanyId,
    c.Name,
    c.Domain,
    c.Description,
    c.Location,
    c.Logo,
    c.Sector,
    c.IndustryGroup,
    c.Industry,                                          
    c.SubIndustry,
    'Engagement' AS WorkRelationshipCode,
    e.LeadershipRoleCode AS RoleCode,
    '' AS TechBudgetRangeCode,
    e.Description AS Comments,
    COALESCE((SELECT Keywords FROM CompanyKeywords AS ck WHERE ck.ParentId = c.Id AND GroupName = 'Tags'),'') AS Tags,
    COALESCE((SELECT Keywords FROM CompanyKeywords AS ck WHERE ck.ParentId = c.Id AND GroupName = 'TechCategories'),'') AS TechCategories,    
    COALESCE((SELECT Keywords FROM CompanyKeywords AS ck WHERE ck.ParentId = c.Id AND GroupName = 'Tech'),'') AS Tech        

FROM EngagementResources AS er
JOIN Engagements AS e ON e.Id = er.ParentId
JOIN Clients AS cl ON cl.Id = e.ParentId                   
JOIN Users AS u ON u.Id = er.ResourceId AND er.`RoleCode` = 'Delivery'
JOIN Companies AS c ON c.Id = cl.CompanyId;

CREATE VIEW `UserBadgeExplorers` AS      

SELECT

    b.Id,
    b.Uid,
    u.Uid AS ResourceUid,
    b.Label,
    b.Color,
    b.Description,
    b.Expiration
    
FROM UserBadges AS b
JOIN Users AS u ON u.Id = b.ParentId;

CREATE VIEW `EngagementExplorers` AS
                  
SELECT           
    e.`Id`,
    e.`Uid`,                         
    e.`CreateTime`,
    e.`LastUpdatedTime`,    
    e.`Active` as EngagementActive,
    e.`Description`,
    e.`EngagementTypeCode`,
    e.`BillingArrangementCode`,
    e.`LeadershipRoleCode`,
    e.`PurchaseOrderNo`,
    e.`BillingRateCode`,
    e.`BillingRate`,
    e.`HubspotDealNo`,
    e.`AutomaticInvoicing`,
    e.`SendInvoiceReminders`,
    e.`LastInvoiceReminderSentDate`,
    e.`LocationSourceCode`,
    e.`DefaultLocationState`,
    e.`DefaultLocationZip`,
    e.`DefaultLocationDescription`,
    e.`ForecastLastUpdate`,
    e.`ChargeAdminFee`,
    e.`AdminFeeDescription`,
    e.`AdminFeeAmount`,
    e.`PreEngagementChecklist`,
    e.`PostEngagementChecklist`,
    c.Uid AS ClientUid,         
    c.Active AS ClientActive,
    c.TenantCode,
    c.Name,
    c.City,                             
    c.`State`,                                                                                                                                                       
    COALESCE(u.Uid,'') AS ResourceUid,
    COALESCE(CONCAT(u.LastName,', ', u.FirstName),'') AS Deliverer,    
    COALESCE((SELECT CONCAT( uo.LastName,', ', uo.FirstName) FROM Users uo where uo.Id = e.RevenueOwnerId)  ,'') AS RevenueOwnerName,        
    COALESCE((SELECT CONCAT( ud.LastName,', ', ud.FirstName) FROM EngagementResources AS erd JOIN Users ud ON ud.Id = erd.ResourceId WHERE erd.ParentId = e.Id AND erd.RoleCode = 'Deal AMP' LIMIT 1)  ,'') AS DealAmp,    
    COALESCE((SELECT CONCAT( uh.LastName,', ', uh.FirstName) FROM EngagementResources AS erh JOIN Users uh ON uh.Id = erh.ResourceId WHERE erh.ParentId = e.Id AND erh.RoleCode = 'Home AMP' LIMIT 1)  ,'') AS HomeAmp,    
    COALESCE((SELECT CONCAT( ur.LastName,', ', ur.FirstName) FROM EngagementResources AS erh JOIN Users ur ON ur.Id = erh.ResourceId WHERE erh.ParentId = e.Id AND erh.RoleCode = 'Referral' LIMIT 1)  ,'') AS Referral,                                          
    COALESCE((SELECT SUM(i.Total) FROM Invoices AS i WHERE i.EngagementId = e.Id AND i.Voided = FALSE)  ,0.00) AS TotalInvoiced,
    COALESCE((SELECT SUM(i.Total-i.Balance) FROM Invoices AS i WHERE i.EngagementId = e.Id AND i.Voided = FALSE)  ,0.00) AS TotalPaid,    
    COALESCE( e.ForecastMonth1+e.ForecastMonth2+e.ForecastMonth3+e.ForecastMonth4+e.ForecastMonth5+e.ForecastMonth6+e.ForecastMonth7+e.ForecastMonth8+e.ForecastMonth9+e.ForecastMonth10+e.ForecastMonth11+e.ForecastMonth12 ,0.00) AS ForecastTotal,
    COALESCE((SELECT MIN(i.InvoiceDate) FROM Invoices AS i WHERE i.EngagementId = e.Id AND i.Voided = FALSE)  ,'1883-11-19') AS FirstInvoiceDate,    
    COALESCE((SELECT MAX(i.InvoiceDate) FROM Invoices AS i WHERE i.EngagementId = e.Id AND i.Voided = FALSE)  ,'2200-01-01') AS LastInvoiceDate        

FROM Engagements AS e
JOIN Clients AS c ON c.Id = e.ParentId
LEFT OUTER JOIN EngagementResources AS er ON er.ParentId = e.Id AND er.RoleCode = 'Delivery'
LEFT OUTER JOIN Users AS u ON u.Id = er.ResourceId;

CREATE VIEW `BillExplorers` AS

SELECT                 
                  
    
    b.`Id`,                    
    b.`Uid`,
    b.`LastUpdatedDate`,
    b.`TenantCode`,    
    b.`ExternalBillDocNum`,    
    b.`ExternalBillId`,
    b.`ExternalInvoiceId`,
    b.`ExternalInvoiceDocNum`,
    b.`Description`,
    u.`Uid` AS ResourceUid,
    CONCAT(u.FirstName, ' ', u.LastName) AS Payee,    
    b.`TrxDate`,                          
    b.`DueDate`,
    b.`CurrencyCode`,
    b.`Total`,
    b.`PaidDate`,
    b.`Balance`,    
    i.`ExternalInvoiceDocNum` AS InvoiceDocNum,    
    i.`EngagementDescription`,      
    i.`ClientName`,
    i.`DelivererName`,
    i.Total AS InvoiceTotal,
    i.InvoiceDate,
    i.PaidStatusCode AS InvoiceStatusCode,    
    b.ServicesTotal,    
    b.ExpensesTotal,
    b.SplitTotal,
    b.WithholdingTotal,
    b.CapitalTotal,    
    i.Balance AS InvoiceBalance,
    coalesce((i.Balance / i.Total),0.00) AS InvoiceUnpaidRatio,
    COALESCE((b.Balance / b.Total),0.00) AS BillUnpaidRatio,
    COALESCE(b.Balance - (b.Total * (i.Balance / i.Total)), 0.00) AS AdjustedBillPayment,
    b.ProcessCode,
    b.ErrorMessage

FROM Bills AS b
JOIN Invoices AS i ON i.`ExternalInvoiceId` = b.`ExternalInvoiceId`
JOIN Users AS u ON u.Id = b.ResourceId ;

CREATE VIEW `VendorExplorers` AS


SELECT   

    v.Id,
    v.Uid,
    c.Name AS VendorName,
    v.Offering,
    v.Description,
    COALESCE((SELECT COUNT(*) FROM VendorReviews AS vr1 WHERE v.Id = vr1.ParentId),0) AS ReviewCount,
    COALESCE((SELECT MAX(LastUpdatedTime) FROM VendorReviews AS vr2 WHERE v.Id = vr2.ParentId),'1883-11-19 00:00:00') AS LatestReviewDate

FROM Vendors AS v
JOIN Companies AS c ON c.Id = v.CompanyId;

CREATE VIEW `PayableBills` AS          
SELECT                         
    b.`Id`,         
    b.`Uid`,
    b.`LastUpdatedDate`, 
    b.`TenantCode`,    
    b.`ExternalBillDocNum`,
    b.`ExternalBillId`,
    b.`ExternalInvoiceId`,
    b.`ExternalInvoiceDocNum`,
    b.`Description`,
    u.`Uid` AS ResourceUid,
    CONCAT(u.FirstName, ' ', u.LastName) AS Payee,
    b.`TrxDate`,          
    b.`DueDate`,            
    b.`CurrencyCode`,
    b.`Total`,
    b.`Balance`,
    (CASE b.ProcessCode WHEN '' THEN 'Ready' ELSE b.ProcessCode END) AS StatusCode,
    b.ProcessCode,
    b.ErrorMessage,
    i.`ExternalInvoiceDocNum` AS InvoiceDocNum,    
    i.`EngagementDescription`,
    i.`ClientName`,        
    i.`DelivererName`,      
    i.Total AS InvoiceTotal,      
    i.Balance AS InvoiceBalance,
    COALESCE((SELECT MAX(PaidDate) FROM InvoicePayments AS ip WHERE ip.ParentId = i.Id),'1883-11-19 00:00:00') AS PaidDate,    
    (i.Balance / i.Total) AS InvoiceUnpaidRatio,
    (b.Balance / b.Total) AS BillUnpaidRatio,
    b.Balance - (b.Total * (i.Balance / i.Total)) AS AdjustedBillPayment    

FROM Bills AS b            
JOIN Invoices AS i ON i.`ExternalInvoiceId` = b.`ExternalInvoiceId`
JOIN Users AS u ON u.Id = b.ResourceId

WHERE i.Balance = 0
and i.Voided = 0
and b.Balance > 0
AND b.ProcessCode NOT IN ('Approved')
AND i.Balance < i.Total
AND (b.Balance / b.Total) > (i.Balance / i.Total);                                                                                                                                   ;

CREATE VIEW `PayoutDetailExplorers` AS

SELECT
        
    bpl.Id AS Id,
    bpl.Uid AS Uid,
    bp.Uid AS BillPaymentUid,
    b.Uid AS BillUid,
    b.`ExternalBillDocNum` AS BillDocNum,
    i.Uid AS InvoiceUid,
    i.`ExternalInvoiceDocNum` AS InvoiceDocNum,
    i.InvoiceDate,
    i.Total,
    i.ClientName            AS ClientName,
    i.EngagementDescription AS EngagementDescription,
    i.DelivererName         AS DelivererName,
    u.Uid AS PayeeUid,    
    (CONCAT(u.FirstName, ' ', u.LastName)) AS PayeeName,
    COALESCE((SELECT SUM(il.Amount) FROM InvoiceLines AS il WHERE il.ParentId = i.`Id` AND LineTypeCode = 'Services'),0) AS ServicesTotal,
    COALESCE((SELECT SUM(bl.Amount) FROM BillLines AS bl WHERE bl.ParentId = b.`Id` AND TypeCode IN ('Services','DealMP', 'HomeMP', 'Referral', 'GP')),0) AS SplitTotal,

    COALESCE((SELECT SUM(bl.Amount) FROM BillLines AS bl WHERE bl.ParentId = b.`Id` AND TypeCode = 'DealMp'),0) AS DealMpTotal,    
    COALESCE((SELECT SUM(bl.Amount) FROM BillLines AS bl WHERE bl.ParentId = b.`Id` AND TypeCode = 'HomeMp'),0) AS HomeMpTotal,
    COALESCE((SELECT SUM(bl.Amount) FROM BillLines AS bl WHERE bl.ParentId = b.`Id` AND TypeCode = 'GP'),0) AS GeneralPartnerTotal,
    COALESCE((SELECT SUM(bl.Amount) FROM BillLines AS bl WHERE bl.ParentId = b.`Id` AND TypeCode = 'Referral'),0) AS ReferralTotal,

    COALESCE((SELECT SUM(bl.Amount) FROM BillLines AS bl WHERE bl.ParentId = b.`Id` AND TypeCode = 'Withholding'),0) AS WithholdingTotal,
    COALESCE((SELECT SUM(bl.Amount) FROM BillLines AS bl WHERE bl.ParentId = b.`Id` AND TypeCode = 'CapitalDeferral'),0) AS CaptialDeferalTotal,    
    COALESCE((SELECT SUM(bl.Amount) FROM BillLines AS bl WHERE bl.ParentId = b.`Id` AND TypeCode = 'Expenses'),0) AS ExpensesTotal,
    bpl.Amount AS BillPaymentTotal

    
FROM BillPaymentLines AS bpl
JOIN BillPayments AS bp ON bp.Id = bpl.`ParentId`
JOIN Bills AS b ON b.Id = bpl.`BillId`
JOIN Invoices AS i ON i.`ExternalInvoiceId` = b.`ExternalInvoiceId`
JOIN Users AS u ON u.Id = b.ResourceId;

CREATE VIEW `PayoutExplorers` AS

SELECT

    bp.Id AS Id,
    bp.Uid AS Uid,
    bp.`TrxDate` AS PaymentDate,
    bp.`Total` AS PaymentTotal,
    u.Id AS PayeeId,
    u.Uid AS PayeeUid,    
    (CONCAT(u.FirstName, ' ', u.LastName)) AS PayeeName,
    (SELECT CASE WHEN COUNT(i.ClientName) = 1 THEN MIN(i.ClientName) ELSE 'Multiple Clients' END AS ClientName FROM BillPaymentLines AS bpl JOIN Bills AS b ON b.Id = bpl.BillId JOIN Invoices AS i ON i.ExternalInvoiceId = b.`ExternalInvoiceId` WHERE bpl.ParentId = bp.Id) AS ClientName    
    
FROM BillPayments AS bp
JOIN Users AS u ON u.Id = bp.ResourceId;
