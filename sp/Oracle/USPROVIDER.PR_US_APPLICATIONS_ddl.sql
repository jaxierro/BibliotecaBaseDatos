-- Start of DDL Script for Package USPROVIDER.PR_US_APPLICATIONS
-- Generated 28-Feb-2011 10:50:07 from USPROVIDER@COPIAPRE.world

CREATE OR REPLACE 
PACKAGE pr_us_applications is

  -- Author  : ROGER.ROWE
  -- Created : 11/1/2006 8:00:16 AM
  -- Purpose : Support the APPLICATIONS

  -- Public type declarations
 -- ** identifies procedures that
 type curtype_APPLICATIONS is ref cursor;

  -- Public function and procedure declarations
 procedure GetApplicationId (
  pApplicationId in out NUMBER,
  pApplicationName VARCHAR2
 );

  -- ** Public function and procedure declarations
 procedure CreateApplication (
  pApplicationId in out NUMBER,
  pApplicationName VARCHAR2,
  pDescription VARCHAR2 default null
 );

  -- Public function and procedure declarations
 procedure UpdateApplicationInfo (
  pOldApplicationName VARCHAR2,
  pNewApplicationName VARCHAR2,
  pDescription VARCHAR2 default null,
    pStatus in out NUMBER
 );

  -- Public function and procedure declarations
 procedure DeleteApplication (
  pApplicationName VARCHAR2,
    pStatus in out NUMBER
 );

  -- Public function and procedure declarations
 procedure FindApplicationByName (
    pResultSet  in out curtype_APPLICATIONS,
  pNameToMatch VARCHAR2
 );

  -- Public function and procedure declarations
 procedure GetAllApplications (
    pResultSet  in out curtype_APPLICATIONS
 );

end pr_us_APPLICATIONS;
-- END PL/SQL BLOCK (do not remove this line) ----------------------------------
/


CREATE OR REPLACE 
PACKAGE BODY pr_us_applications is

 -- now for standard restrictions, expect my to place the
 -- constraint upon the object and not upon the method. that
 -- is, unique values by index rather than code.

  -- Public function and procedure declarations
 procedure GetApplicationId (
  pApplicationId in out NUMBER,
  pApplicationName VARCHAR2
 ) as
  begin
  select /*+ FIRST_ROWS */ ApplicationId
  into pApplicationId
  from us_APPLICATIONS
  where lower(trim(ApplicationName)) = lower(trim(pApplicationName));
  end;

  -- Public function and procedure declarations
 procedure CreateApplication (
  pApplicationId in out NUMBER,
  pApplicationName VARCHAR2,
  pDescription VARCHAR2 default null
 ) as
  begin
  insert into us_APPLICATIONS
   (
    ApplicationName,
    Description
   ) values (
    pApplicationName,
    pDescription
   ) returning ApplicationId into pApplicationId;
  end;

  -- Public function and procedure declarations
 procedure UpdateApplicationInfo (
  pOldApplicationName VARCHAR2,
  pNewApplicationName VARCHAR2,
  pDescription VARCHAR2 default null,
    pStatus in out NUMBER
 ) as
  vApplicationID NUMBER;
  begin
  PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pOldApplicationName);

  update us_APPLICATIONS a
   set a.applicationname = pNewApplicationName
    ,a.description = pDescription
  where a.applicationid = vApplicationID;

  pStatus := sql%rowcount;
  end;

  -- Public function and procedure declarations
 procedure DeleteApplication (
  pApplicationName VARCHAR2,
    pStatus in out NUMBER
 ) as
  vApplicationID NUMBER;
  begin
  PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);

  delete from us_APPLICATIONS a
  where a.applicationid = vApplicationID;

  pStatus := sql%rowcount;
  end;

  -- Public function and procedure declarations
 procedure FindApplicationByName (
    pResultSet  in out curtype_APPLICATIONS,
  pNameToMatch VARCHAR2
 ) as
  vApplicationID NUMBER;
  begin
  PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pNameToMatch);

    open pResultSet for
   select
    a.APPLICATIONID
    ,a.APPLICATIONNAME
    ,a.DESCRIPTION
      from us_APPLICATIONS a
   where a.applicationid = vApplicationID;
  end;

  -- Public function and procedure declarations
 procedure GetAllApplications (
    pResultSet  in out curtype_APPLICATIONS
 ) as
  begin
    open pResultSet for
      select rownum rnum,b.*
   from (
    select *
    from us_APPLICATIONS a
       order by a.APPLICATIONNAME
   ) b;
  end;

end pr_us_APPLICATIONS;
-- END PL/SQL BLOCK (do not remove this line) ----------------------------------
/


-- End of DDL Script for Package USPROVIDER.PR_US_APPLICATIONS

