-- Start of DDL Script for Package USPROVIDER.PR_US_MEMBERSHIP
-- Generated 28-Feb-2011 10:50:16 from USPROVIDER@COPIAPRE.world

CREATE OR REPLACE 
PACKAGE pr_us_membership is

  -- Author  : ROGER ROWE
  -- Created : 10/31/2006 7:06:20 PM
  -- Purpose : Support the MEMBERSHIPPROVIDER

	-- when the userid is obtained - as this is a unique value
	-- in itself. this means many of the parameters may not actually
	-- be needed for functionality.
	-- as i remember from my old development of a provider there was
	-- a problem with oracle functions. so some are procedures as
	-- opposed to functions. i can change this easiliy and provide
	-- simple counts.

	-- single user account under different applications?

  -- PERFORMANCE CHECKS INCOMPLETE ON THE QUERIES.
  -- LET ME KNOW IF THERE ARE ISSUES.

  -- i basically, tried to provide the same functionality as other
  -- packages, which may mean additional calls at the interface, but
  -- i can always provide additional/alternative methods.

  -- Public type declarations
	type curtype_MEMBERSHIP is ref cursor;

  -- Public function and procedure declarations
	-- internal
	procedure SetLastActivityDate (
		pUserID  NUMBER
	);

  -- Public function and procedure declarations
	-- internal
	procedure SetLastLoginDate (
		pUserID  NUMBER
	);

  -- Public function and procedure declarations
	-- internal
	function GetUserId (
		pApplicationID	NUMBER,
		pUserName		VARCHAR2
	) return NUMBER;

	-- =================================================
	-- =================================================

 	-- Public function and procedure declarations
	procedure CreateUser (
		pUserId	in out NUMBER,
		pApplicationName  VARCHAR2,
        pUserName  VARCHAR2,
    pPassword  VARCHAR2,
    pPasswordFormat  NUMBER,
    pPasswordSalt  VARCHAR2,
    pEmail VARCHAR2,
    pPasswordQuestion  VARCHAR2,
    pPasswordAnswer  VARCHAR2,
    pIsApproved  NUMBER default 0,
    pIsLockedOut NUMBER default 0
	);

  -- Public function and procedure declarations
	procedure GetUserByUserId (
    pResultSet  in out curtype_MEMBERSHIP,
		pUserId		NUMBER,
		pUpdateLastActivityDate NUMBER default 0
	);

  -- Public function and procedure declarations
	function FGetUserByUserId (
		pUserId		NUMBER,
		pUpdateLastActivityDate NUMBER default 0
	) return curtype_MEMBERSHIP;

  -- Public function and procedure declarations
	procedure GetUserByUserName (
    pResultSet  in out curtype_MEMBERSHIP,
		pApplicationName  VARCHAR2,
		pUserName		VARCHAR2,
		pUpdateLastActivityDate NUMBER default 0
	);

  -- Public function and procedure declarations
	function FGetUserByUserName (
		pApplicationName  VARCHAR2,
		pUserName		VARCHAR2,
		pUpdateLastActivityDate NUMBER default 0
	) return curtype_MEMBERSHIP;

  -- Public function and procedure declarations
	procedure GetUserByEmail (
    pResultSet  in out curtype_MEMBERSHIP,
		pApplicationName  VARCHAR2,
		pEmail		VARCHAR2
	);

  -- Public function and procedure declarations
	function FGetUserByEmail (
		pApplicationName  VARCHAR2,
		pEmail		VARCHAR2
	) return curtype_MEMBERSHIP;

  -- Public function and procedure declarations
	procedure GetPasswordWithFormat (
        pResultSet  out curtype_MEMBERSHIP,
		pApplicationName  VARCHAR2,
		pUserName		VARCHAR2,
		pUpdateLastActivityDate NUMBER default 0,
        pStatus out NUMBER
	);

  -- Public function and procedure declarations
	function FGetPasswordWithFormat (
		pApplicationName  VARCHAR2,
		pUserName		VARCHAR2,
		pUpdateLastActivityDate NUMBER default 0,
    pStatus in out NUMBER
	) return curtype_MEMBERSHIP;

 	-- Public function and procedure declarations
	procedure UpdateUserInfo (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
    pIsPasswordCorrect NUMBER default 0,
		pUpdateLastActivityDate NUMBER default 0,
		pPwdAttemptWindow	NUMBER default 0,
		pMaxFailedPwdAttempts	NUMBER default 0,
    pStatus in out NUMBER
	);

 	-- Public function and procedure declarations
	procedure GetPassword (
    pResultSet  in out curtype_MEMBERSHIP,
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pMaxFailedPwdAttempts	NUMBER default 0,
		pPwdAttemptWindow	NUMBER default 0,
		pPwdAnswer  VARCHAR2 default null,
    pStatus in out NUMBER
	);

 	-- Public function and procedure declarations
	function FGetPassword (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pMaxFailedPwdAttempts	NUMBER default 0,
		pPwdAttemptWindow	NUMBER default 0,
		pPwdAnswer  VARCHAR2 default null,
    pStatus in out NUMBER
	) return curtype_MEMBERSHIP;

  -- Public function and procedure declarations
	procedure SetPassword (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pNewPassword	VARCHAR2,
		pPasswordSalt	VARCHAR2,
		pPasswordFormat	NUMBER default 0,
    pStatus in out NUMBER
	);

  -- Public function and procedure declarations
	procedure ResetPassword (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pNewPassword	VARCHAR2,
    pMaxInvalidPwdAttempts NUMBER,
    pPasswordAttemptWindow  NUMBER,
		pPasswordSalt	VARCHAR2,
		pPasswordFormat	NUMBER default 0,
		pPasswordAnswer	VARCHAR2 default NULL,
    pStatus in out NUMBER
	);

 	-- Public function and procedure declarations
	procedure UnlockUser (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pUserId	in out NUMBER
	);

 	-- Public function and procedure declarations
	procedure UpdateUser (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
    pEmail VARCHAR2,
    pIsApproved  NUMBER default 0,
		pUpdateLastActivityDate NUMBER default 0,
		pUpdateLastLoginDate NUMBER default 0,
    pStatus in out NUMBER
	);

  -- Public function and procedure declarations
	procedure ChangePasswordQAndA (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pNewQuestion	VARCHAR2,
		pNewAnswer		VARCHAR2,
    pStatus in out NUMBER
	);

  -- Public function and procedure declarations
	procedure GetAllUsers (
    pResultSet   out curtype_MEMBERSHIP,
    pTotalRecords in out NUMBER,
		pApplicationName  VARCHAR2,
		pPageIndex		NUMBER default 1,
		pPageSize		NUMBER default 0
	);

  -- Public function and procedure declarations
	function FGetAllUsers (
    pTotalRecords in out NUMBER,
		pApplicationName  VARCHAR2,
		pPageIndex		NUMBER default 1,
		pPageSize		NUMBER default 0
	) return curtype_MEMBERSHIP;

  -- Public function and procedure declarations
	procedure GetNumberOfUsersOnline (
    pCount in out NUMBER,
		pApplicationName  VARCHAR2,
		pMinutesSinceLastInActive  NUMBER
	);

  -- Public function and procedure declarations
	procedure FindUsersByName (
    pResultSet  in out curtype_MEMBERSHIP,
    pTotalRecords in out NUMBER,
		pApplicationName  VARCHAR2,
		pUserNameToMatch	VARCHAR2 default '%%',
		pPageIndex		NUMBER default 1,
		pPageSize		NUMBER default 10
	);

  -- Public function and procedure declarations
	function FFindUsersByName (
    pTotalRecords in out NUMBER,
		pApplicationName  VARCHAR2,
		pUserNameToMatch	VARCHAR2 default '%%',
		pPageIndex		NUMBER default 1,
		pPageSize		NUMBER default 10
	) return curtype_MEMBERSHIP;

  -- Public function and procedure declarations
	procedure FindUsersByEmail (
    pResultSet  in out curtype_MEMBERSHIP,
    pTotalRecords in out NUMBER,
		pApplicationName  VARCHAR2,
		pEmailToMatch	VARCHAR2 default '%%',
		pPageIndex		NUMBER default 1,
		pPageSize		NUMBER default 10
	);

  -- Public function and procedure declarations
	function FFindUsersByEmail (
    pTotalRecords in out NUMBER,
		pApplicationName  VARCHAR2,
		pEmailToMatch	VARCHAR2 default '%%',
		pPageIndex		NUMBER default 1,
		pPageSize		NUMBER default 10
	) return curtype_MEMBERSHIP;

  -- Public function and procedure declarations
	procedure DeleteUser (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
    pStatus in out NUMBER
	);










/*
  -- Public function and procedure declarations
	procedure UpdateUserEmail (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pEmail		VARCHAR2
	);

  -- Public function and procedure declarations
	procedure UserAuthenticated (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2
	);

 	-- Public function and procedure declarations
	procedure UpdateUserLogonInfo (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
    pIsApproved NUMBER,
    pIsLockedOut  NUMBER,
    pFailedPswdAttemptCount  NUMBER,
    pSetPswdAttemptWindowStart  DATE DEFAULT SYSDATE,
    pFailedPswdAnsAttemptCount  NUMBER,
    pSetPswdAnsAttemptWinStart  DATE DEFAULT SYSDATE
	);

  -- Public function and procedure declarations
	procedure FindUsersByEmailCount (
    pCount in out NUMBER,
		pApplicationName  VARCHAR2,
		pEmailToMatch	VARCHAR2 default '%%'
	);

  -- Public function and procedure declarations
	procedure FindUsersByUserNameCount (
    pCount in out NUMBER,
		pApplicationName  VARCHAR2,
		pUserNameToMatch	VARCHAR2 default '%%'
	);

  -- Public function and procedure declarations
	procedure GetUsersCount (
    pCount in out NUMBER,
		pApplicationName  VARCHAR2
	);

-- todo add counts for various results where paging is used.

  ApplicationId                          number not null,
  UserId                                 number not null,
  *LastActivityDate 											 date default sysdate not null,
  UserName         											 varchar2(256) not null,
  *Password                               varchar2(128) not null,
  *PasswordFormat                         number not null,
  *PasswordSalt                           varchar2(128) not null,
  *PasswordQuestion                       varchar2(256) not null,
  *PasswordAnswer                         varchar2(128) not null,
  *CreateDate                             date default sysdate not null,
  *LastPasswordChangedDate                date default sysdate not null,
  *IsLockedOut                            varchar2(1) default 'N' not null,
  *LastLockoutDate                        date default sysdate not null,
  *FailedPswdAttemptCount                 number default 0 not null,
  *FailedPswdAttemptWindowStart           date default sysdate not null,
  *FailedPswdAnsAttemptCount              number default 0 not null,
  *FailedPswdAnsAttemptWinStart           date default sysdate not null,
  IsApproved                             number default 0 not null,
  IsLockedOut                            number default 0 not null,
  *LastLoginDate                          date default sysdate not null,
*/

PROCEDURE InsertUserApplication(pUserId IN NUMBER, pApplicationID NUMBER);

PROCEDURE DeleteUserApplication(pUserId IN NUMBER, pApplicationID NUMBER);

PROCEDURE DeleteUserAllApplication(pUserId IN NUMBER);

FUNCTION VerifyUserApplication (pUserId IN NUMBER, pApplicationID NUMBER) RETURN VARCHAR2;

FUNCTION VerifyUserNameApplicationName (pUserName IN VARCHAR2, pApplicationName VARCHAR2) RETURN VARCHAR2;

   	procedure UpdateUserExtraInfo (
       	pApplicationName  VARCHAR2,
        pUserName         VARCHAR2,
        pFirstName        VARCHAR2,
        pLastName         VARCHAR2,
        pTipoId           VARCHAR2,
        pNumId            NUMBER
	);

   	procedure GetUserExtraInfo (
   	    pResultSet  in out curtype_MEMBERSHIP,
		pApplicationName  VARCHAR2,
        pUserName         VARCHAR2
   	);

   	-- Public function and procedure declarations
	procedure AssociateUserToApplication (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pUserId	out NUMBER
	);

    -- Public function and procedure declarations
	procedure DisassociatesUserToApplication (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pUserId	out NUMBER
	);

	FUNCTION FGetFullName(vusername IN VARCHAR2) RETURN VARCHAR2;

end pr_us_membership;
-- END PL/SQL BLOCK (do not remove this line) ----------------------------------
/


CREATE OR REPLACE 
PACKAGE BODY                       pr_us_membership is

  -- Public function and procedure declarations
	-- internal
	procedure SetLastActivityDate (
		pUserID  NUMBER
	) as
	begin
		update us_MEMBERSHIP a
		set LastActivityDate = sysdate
		where a.USERID = pUserID;
	end;

  -- Public function and procedure declarations
	-- internal
	procedure SetLastLoginDate (
		pUserID  NUMBER
	) as
	begin
		update us_MEMBERSHIP a
		set a.LastLoginDate = sysdate
		where a.USERID = pUserID;
	end;

  -- Public function and procedure declarations
	-- internal
	function GetUserId (
		pApplicationID	NUMBER,
		pUserName		VARCHAR2
	) return NUMBER as
		vUserID	NUMBER;
  begin
        select /*+ FIRST_ROWS */ a.USERID
		  into vUserID
          from  us_MEMBERSHIP_APPLICATION B, us_MEMBERSHIP a
         where B.APPLICATIONID = pApplicationID
           and lower(trim(a.USERNAME)) = lower(trim(pUserName))
           and b.userid = a.userid;

		return vUserID;
  end;

	-- =================================================
	-- =================================================

 	-- Public function and procedure declarations
	procedure CreateUser (
		pUserId	in out NUMBER,
		pApplicationName  VARCHAR2,
        pUserName  VARCHAR2,
        pPassword  VARCHAR2,
        pPasswordFormat  NUMBER,
        pPasswordSalt  VARCHAR2,
        pEmail VARCHAR2,
        pPasswordQuestion  VARCHAR2,
        pPasswordAnswer  VARCHAR2,
        pIsApproved  NUMBER default 0,
        pIsLockedOut NUMBER default 0
	) as
		vApplicationID NUMBER;
		vexiste number;
  begin
        begin
            PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
        exception when others then
            return;
        end;

       begin
          select 1
            into vexiste
            from us_MEMBERSHIP
           where userName = pUserName;
       exception
          when no_Data_found then
  	         insert into us_MEMBERSHIP (
                UserName,
                Password,
                PasswordFormat,
                PasswordSalt,
                Email,
                PasswordQuestion,
                PasswordAnswer,
                IsApproved,
                IsLockedOut
            ) values (
                pUserName,
                pPassword,
                pPasswordFormat,
                pPasswordSalt,
                pEmail,
                pPasswordQuestion,
                pPasswordAnswer,
                pIsApproved,
                pIsLockedOut
                ) returning UserId into pUserId;
       end;

        -- Colocado temporalmente para agregar el usuario a la aplicacion,
        -- a futuro esto sera hecho por un proceso aparte.
        InsertUserApplication(pUserId, vApplicationID);

  end;

  -- Public function and procedure declarations
	procedure GetUserByUserId (
        pResultSet  in out curtype_MEMBERSHIP,
		pUserId		NUMBER,
		pUpdateLastActivityDate NUMBER default 0
	) as
  begin
		if (pUpdateLastActivityDate = 1) then
			PR_US_MEMBERSHIP.SETLASTACTIVITYDATE(pUserId);
		end if;

        open pResultSet for
            select /*+ FIRST_ROWS */
				a.email
				,a.passwordquestion
				,a.isapproved
				,a.createdate
				,a.lastlogindate
				,a.lastactivitydate
				,a.lastpasswordchangeddate
				,a.userid
				,a.islockedout
				,a.lastlockoutdate
             from us_MEMBERSHIP a
            where a.USERID = pUserId;

  end;

  -- Public function and procedure declarations
	function FGetUserByUserId (
		pUserId		NUMBER,
		pUpdateLastActivityDate NUMBER default 0
	) return curtype_MEMBERSHIP as
        vResultSet  curtype_MEMBERSHIP;
	begin
		GetUserByUserId(vResultSet,pUserId,pUpdateLastActivityDate);
		return vResultSet;
	end;

  -- Public function and procedure declarations
	procedure GetUserByUserName (
    pResultSet  in out curtype_MEMBERSHIP,
		pApplicationName  VARCHAR2,
		pUserName	VARCHAR2,
		pUpdateLastActivityDate NUMBER default 0
	) as
		vApplicationID NUMBER;
		vUserID	NUMBER;
  begin
		PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
		vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);
		PR_US_MEMBERSHIP.GETUSERBYUSERID(pResultSet,vUserID,pUpdateLastActivityDate);
  end;

  -- Public function and procedure declarations
	function FGetUserByUserName (
		pApplicationName  VARCHAR2,
		pUserName		VARCHAR2,
		pUpdateLastActivityDate NUMBER default 0
	) return curtype_MEMBERSHIP as
        vResultSet  curtype_MEMBERSHIP;
	begin
		GetUserByUserName(vResultSet,pApplicationName,pUserName,pUpdateLastActivityDate);
		return vResultSet;
	end;

  -- Public function and procedure declarations
	procedure GetUserByEmail (
        pResultSet  in out curtype_MEMBERSHIP,
		pApplicationName  VARCHAR2,
		pEmail		VARCHAR2
	) as
		vApplicationID NUMBER;
  begin
		PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
        open pResultSet for
			select a.USERNAME
			  from  us_MEMBERSHIP_APPLICATION B, us_MEMBERSHIP a
             where B.APPLICATIONID = vApplicationID
		       and lower(trim(a.EMAIL)) = lower(trim(pEmail))
		       and b.isdeleted = 0;
  end;

  -- Public function and procedure declarations
	function FGetUserByEmail (
		pApplicationName  VARCHAR2,
		pEmail		VARCHAR2
	) return curtype_MEMBERSHIP as
        vResultSet  curtype_MEMBERSHIP;
	begin
		GetUserByEmail(vResultSet,pApplicationName,pEmail);
		return vResultSet;
	end;

  -- Public function and procedure declarations
	procedure GetPasswordWithFormat (
        pResultSet  out curtype_MEMBERSHIP,
		pApplicationName  VARCHAR2,
		pUserName		VARCHAR2,
		pUpdateLastActivityDate NUMBER default 0,
        pStatus out NUMBER
	) as
		vApplicationID NUMBER := 0;
		vUserID	NUMBER  := 0;
		vIsApproved	NUMBER;
		vIsLockedOut	NUMBER;
  begin
        		pStatus := 0;
        begin
    		PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
		EXCEPTION WHEN NO_DATA_FOUND THEN
		      	pStatus := -91;
		      	vApplicationID := 0;
 	    END;

 	    begin
		  vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);
        EXCEPTION WHEN NO_DATA_FOUND THEN
		      	pStatus := -91;
		      	vUserID := 0;
 	    END;

        begin

		select /*+ FIRST_ROWS */ A.ISAPPROVED,A.ISLOCKEDOUT
		  into vIsApproved,vIsLockedOut
		  from us_MEMBERSHIP_APPLICATION B, us_MEMBERSHIP A
         where B.APPLICATIONID = vApplicationID
           and A.USERID        = vUserID
           and B.USERID        = vUserId
           AND A.ISDELETED     = 0
           AND B.isdeleted     = 0;
		exception when no_data_found then
		  vIsApproved := 0;
          vIsLockedOut := 0;
		end;
		if (vIsLockedOut = 1) then
			pStatus := -81;
		end if;

		if (pUpdateLastActivityDate = 1) and (vIsApproved = 1)then
			PR_US_MEMBERSHIP.SETLASTACTIVITYDATE(vUserId);
            PR_US_MEMBERSHIP.SETLASTLOGINDATE(vUserId);
		end if;

        open pResultSet for
            select /*+ FIRST_ROWS */
                 PASSWORD
                ,PASSWORDFORMAT
                ,PASSWORDSALT
                ,FAILEDPSWDATTEMPTCOUNT
                ,FAILEDPSWDANSATTEMPTCOUNT
                ,ISAPPROVED
                ,LASTLOGINDATE
				,LASTACTIVITYDATE
                ,A.USERID
            from us_MEMBERSHIP_APPLICATION B, us_MEMBERSHIP a
           where B.APPLICATIONID = vApplicationID
             and B.USERID        = vUserID
             and A.USERID        = vUserID
             AND A.ISDELETED     = 0
             AND B.isdeleted     = 0;


  end;

  -- Public function and procedure declarations
	function FGetPasswordWithFormat (
		pApplicationName  VARCHAR2,
		pUserName		VARCHAR2,
		pUpdateLastActivityDate NUMBER default 0,
        pStatus in out NUMBER
	) return curtype_MEMBERSHIP as
        vResultSet  curtype_MEMBERSHIP;
	begin
		GetPasswordWithFormat(vResultSet,pApplicationName,pUserName,pUpdateLastActivityDate,pStatus);
		return vResultSet;
	end;

 	-- Public function and procedure declarations
	procedure UpdateUserInfo (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
        pIsPasswordCorrect NUMBER default 0,
		pUpdateLastActivityDate NUMBER default 0,
		pPwdAttemptWindow	NUMBER default 0,
		pMaxFailedPwdAttempts	NUMBER default 0,
        pStatus in out NUMBER
	) as
		vApplicationID                  NUMBER;
		vUserID	                        NUMBER;
		vIsApproved	                    NUMBER;
		vIsLockedOut	                NUMBER;
		vLastLockoutDate	            DATE;
		vFailedPwdAttemptCount	        NUMBER;
		vFailedPwdAttemptWinStart	    DATE;
		vFailedPwdAnsAttemptCount	    NUMBER;
		vFailedPwdAnsAttemptWinStart	DATE;
  begin
        -- forced good status
		pStatus := 1;
        vApplicationID := 0;
        vUserID        := 0;
        begin
            PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            pStatus := -91;
            RETURN;
        END;


		begin
		      vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);
        EXCEPTION WHEN NO_DATA_FOUND THEN
            pStatus := -91;
            RETURN;
        END;

        IF (pStatus = 1) then
		select /*+ FIRST_ROWS */
			a.ISAPPROVED
			,a.ISLOCKEDOUT
			,a.LASTLOCKOUTDATE
			,a.FAILEDPSWDATTEMPTCOUNT
			,a.FAILEDPSWDATTEMPTWINDOWSTART
			,a.FAILEDPSWDANSATTEMPTCOUNT
			,a.FAILEDPSWDANSATTEMPTWINSTART
		into
  		    vIsApproved
  		    ,vIsLockedOut
  		    ,vLastLockoutDate
  		    ,vFailedPwdAttemptCount
  		    ,vFailedPwdAttemptWinStart
  		    ,vFailedPwdAnsAttemptCount
  		    ,vFailedPwdAnsAttemptWinStart
		from  us_MEMBERSHIP_APPLICATION B, us_MEMBERSHIP a
      where B.APPLICATIONID = vApplicationID
        and B.USERID = vUserID
        and A.USERID = vUserID
        AND A.ISDELETED     = 0
        AND B.isdeleted     = 0;



		-- if locked out then do nothing else
		if (vIsLockedOut = 1) then
			pStatus := -91;
			return;
		end if;

		if (pIsPasswordCorrect = 0) then
  		-- now we have an incorrect password
			-- reset after attempt window
  		if (sysdate >= (vFailedPwdAttemptWinStart + (1/24/60 * pPwdAttemptWindow))) then
				pStatus := -92;
  			vFailedPwdAttemptCount := 1;
  		else
				pStatus := -93;
  			vFailedPwdAttemptCount := vFailedPwdAttemptCount + 1;
  		end if;
  		vFailedPwdAttemptWinStart := sysdate;

			-- have we maxed the attempts
  		if (vFailedPwdAttemptCount > pMaxFailedPwdAttempts) then
  			vIsLockedOut := 1;
  			vLastLockoutDate := sysdate;
				pStatus := -94;
  		end if;
		else
			vFailedPwdAttemptCount := 0;
  		vFailedPwdAttemptWinStart := sysdate;
			vFailedPwdAnsAttemptCount := 0;
			vFailedPwdAnsAttemptWinStart := sysdate;
 			vLastLockoutDate := sysdate;
		end if;

  	if (pUpdateLastActivityDate = 1) then
  		PR_US_MEMBERSHIP.SETLASTACTIVITYDATE(vUserId);
  		PR_US_MEMBERSHIP.SETLASTLOGINDATE(vUserId);
  	end if;

		update us_MEMBERSHIP a
			set A.ISLOCKEDOUT = vIsLockedOut
				,A.LASTLOCKOUTDATE = vLastLockoutDate
				,A.FAILEDPSWDATTEMPTCOUNT = vFailedPwdAttemptCount
				,A.FAILEDPSWDATTEMPTWINDOWSTART = vFailedPwdAttemptWinStart
				,A.FAILEDPSWDANSATTEMPTCOUNT = vFailedPwdAnsAttemptCount
				,A.FAILEDPSWDANSATTEMPTWINSTART = vFailedPwdAnsAttemptWinStart
         where a.USERID    = vUserID
           AND A.isdeleted = 0;
         end if;
	end;

 	-- Public function and procedure declarations
	procedure GetPassword (
        pResultSet  in out curtype_MEMBERSHIP,
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pMaxFailedPwdAttempts	NUMBER default 0,
		pPwdAttemptWindow	NUMBER default 0,
		pPwdAnswer  VARCHAR2 default null,
        pStatus in out NUMBER
	) as
		vApplicationID NUMBER;
		vUserID	NUMBER;
		vPassword	VARCHAR2(128);
		vPasswordAnswer	VARCHAR2(128);
		vPasswordFormat	NUMBER;
		vIsLockedOut	NUMBER;
		vLastLockoutDate	DATE;
		vFailedPwdAttemptCount	NUMBER;
		vFailedPwdAttemptWinStart	DATE;
		vFailedPwdAnsAttemptCount	NUMBER;
		vFailedPwdAnsAttemptWinStart	DATE;
  begin
		PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
		vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);

		-- forced good status
		pStatus := 1;

		select /*+ FIRST_ROWS */
			a.PASSWORD
			,a.PASSWORDANSWER
			,a.PASSWORDFORMAT
			,a.ISLOCKEDOUT
			,a.LASTLOCKOUTDATE
			,a.FAILEDPSWDATTEMPTCOUNT
			,a.FAILEDPSWDATTEMPTWINDOWSTART
			,a.FAILEDPSWDANSATTEMPTCOUNT
			,a.FAILEDPSWDANSATTEMPTWINSTART
		into
			vPassword
			,vPasswordAnswer
			,vPasswordFormat
  		    ,vIsLockedOut
  		    ,vLastLockoutDate
  		    ,vFailedPwdAttemptCount
  		    ,vFailedPwdAttemptWinStart
  		    ,vFailedPwdAnsAttemptCount
  		    ,vFailedPwdAnsAttemptWinStart
		from us_MEMBERSHIP_APPLICATION B, us_MEMBERSHIP A
       where A.userid        = vUserID
         AND B.APPLICATIONID = vApplicationID
         and B.USERID        = vUserID
         AND A.ISDELETED     = 0
         AND B.isdeleted     = 0;

		if (vIsLockedOut = 1) then
			pStatus := -101;
			return;
		end if;

		if (not (vPasswordAnswer is null)) then

			if ((pPwdAnswer is null) or (not (lower(trim(pPwdAnswer)) = lower(trim(vPasswordAnswer))) )) then

				if (sysdate >= (vFailedPwdAnsAttemptWinStart + (1/24/60 * pPwdAttemptWindow))) then
					pStatus := -102;
					vFailedPwdAnsAttemptCount := 1;
				else
					pStatus := -103;
					vFailedPwdAnsAttemptCount := vFailedPwdAnsAttemptCount + 1;
				end if;

				if (vFailedPwdAnsAttemptCount > pMaxFailedPwdAttempts) then
					pStatus := -104;
					vIsLockedOut := 1;
					vLastLockoutDate := sysdate;
				end if;
			else
				vFailedPwdAnsAttemptCount := 0;
			end if;

		end if;
		vFailedPwdAnsAttemptWinStart := sysdate;

 		update us_MEMBERSHIP a
 			set A.FAILEDPSWDANSATTEMPTCOUNT = vFailedPwdAnsAttemptCount
 				,A.FAILEDPSWDANSATTEMPTWINSTART = vFailedPwdAnsAttemptWinStart
 				,A.ISLOCKEDOUT = vIsLockedOut
 				,A.LASTLOCKOUTDATE = vLastLockoutDate
		where a.USERID = vUserID
          AND A.ISDELETED = 0;

		if (not (vFailedPwdAnsAttemptCount = 0)) then
			return;
		end if;

		pStatus := sql%rowcount;

		-- give the resultset
        open pResultSet for
            select /*+ FIRST_ROWS */
                   PASSWORD
                  ,PASSWORDFORMAT
              from us_MEMBERSHIP_APPLICATION A, us_MEMBERSHIP b
             where A.userid        = vUserID
               AND A.APPLICATIONID = vApplicationID
               and B.USERID = vUserID
               AND B.ISDELETED = 0
               AND A.isdeleted = 0;
	end;

 	-- Public function and procedure declarations
	function FGetPassword (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pMaxFailedPwdAttempts	NUMBER default 0,
		pPwdAttemptWindow	NUMBER default 0,
		pPwdAnswer  VARCHAR2 default null,
        pStatus in out NUMBER
	) return curtype_MEMBERSHIP as
        vResultSet  curtype_MEMBERSHIP;
	begin
		GetPassword(vResultSet,pApplicationName,pUserName,pMaxFailedPwdAttempts,pPwdAttemptWindow,pPwdAnswer,pStatus);
		return vResultSet;
	end;

  -- Function and procedure implementations
	procedure SetPassword (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pNewPassword	VARCHAR2,
		pPasswordSalt	VARCHAR2,
		pPasswordFormat	NUMBER default 0,
        pStatus in out NUMBER
	) as
		vApplicationID NUMBER;
		vUserID	NUMBER;
		vVerified VARCHAR2(1);
  begin
		PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
		vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);
		vVerified := VerifyUserApplication(vUserId,vApplicationID);

        if vVerified ='S' THEN
      		update us_MEMBERSHIP a
        	   set Password = pNewPassword,
     			   PasswordFormat = pPasswordFormat,
         		   PasswordSalt = pPasswordSalt,
            	   LastPasswordChangedDate = sysdate
      		 where a.USERID = vUserID
               AND A.ISDELETED = 0;
        END IF;

        pStatus := sql%rowcount;
	end;

  -- Public function and procedure declarations
	procedure ResetPassword (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pNewPassword	VARCHAR2,
        pMaxInvalidPwdAttempts NUMBER,
        pPasswordAttemptWindow  NUMBER,
		pPasswordSalt	VARCHAR2,
		pPasswordFormat	NUMBER default 0,
		pPasswordAnswer	VARCHAR2 default NULL,
        pStatus in out NUMBER
	) as
		vApplicationID NUMBER;
		vUserID	NUMBER;
		vIsLockedOut	NUMBER;
		vLastLockoutDate	DATE;
		vFailedPwdAttemptCount	NUMBER;
		vFailedPwdAttemptWinStart	DATE;
		vFailedPwdAnsAttemptCount	NUMBER;
		vFailedPwdAnsAttemptWinStart	DATE;
		vVerified                     VARCHAR2(1);
  begin
		PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
		vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);

		-- forced UNKNOWN status
		pStatus := 0;
        vVerified := VerifyUserApplication(vUserId,vApplicationID);

        if vVerified = 'S' THEN

            select a.ISLOCKEDOUT,a.LASTLOCKOUTDATE,a.FAILEDPSWDATTEMPTCOUNT,
                   a.FAILEDPSWDATTEMPTWINDOWSTART,a.FAILEDPSWDANSATTEMPTCOUNT,
                   a.FAILEDPSWDANSATTEMPTWINSTART
              into vIsLockedOut, vLastLockoutDate, vFailedPwdAttemptCount,
          		   vFailedPwdAttemptWinStart, vFailedPwdAnsAttemptCount,
           	 	   vFailedPwdAnsAttemptWinStart
              from us_MEMBERSHIP_APPLICATION B, us_MEMBERSHIP a
      		 where B.APPLICATIONID = vApplicationID
               and A.USERID = vUserID
               and B.USERID = vUserID
               AND A.ISDELETED = 0
               AND B.isdeleted = 0;

		      -- if locked out then do nothing else
		      if (vIsLockedOut = 1) then
			     pStatus := -121;
			     return;
		      end if;

        		update us_MEMBERSHIP a
		           set A.PASSWORD = pNewPassword
        			   ,A.PASSWORDFORMAT = pPasswordFormat
            		   ,A.PASSWORDSALT = pPasswordSalt
        			   ,A.LASTPASSWORDCHANGEDDATE = sysdate
                 where a.USERID = vUserID
	               and (
            			(pPasswordAnswer is null)
			             or
            			(lower(trim(pPasswordAnswer)) = lower(trim(a.passwordanswer)))
                		)
                        AND A.ISDELETED = 0;

                if (sql%rowcount = 0) then

  		            if (sysdate >= (vFailedPwdAnsAttemptWinStart + (1/24/60 * pPasswordAttemptWindow))) then
        				pStatus := -122;
  		            	vFailedPwdAnsAttemptCount := 1;
              		else
			         	pStatus := -123;
              			vFailedPwdAnsAttemptCount := vFailedPwdAnsAttemptCount + 1;
              		end if;
	           		vFailedPwdAnsAttemptWinStart := sysdate;

  	             	if (vFailedPwdAnsAttemptCount > pMaxInvalidPwdAttempts) then
        				pStatus := -124;
  		            	vIsLockedOut := 1;
              			vLastLockoutDate := sysdate;
              		end if;

                else

			         -- want a 1 to identify that a record was updated
		             pStatus := sql%rowcount;

                      if (vFailedPwdAnsAttemptCount > 0) then
                        vFailedPwdAnsAttemptWinStart := sysdate;
                        vFailedPwdAnsAttemptCount := 0;
                      end if;

                end if;

        		if (not (pPasswordAnswer is null)) then

  		            update us_MEMBERSHIP a
              		   set A.FAILEDPSWDANSATTEMPTCOUNT = vFailedPwdAnsAttemptCount
              			   ,A.FAILEDPSWDANSATTEMPTWINSTART = vFailedPwdAnsAttemptWinStart
                           ,A.FAILEDPSWDATTEMPTCOUNT = vFailedPwdAttemptCount
                           ,A.FAILEDPSWDATTEMPTWINDOWSTART = vFailedPwdAttemptWinStart
              			   ,A.ISLOCKEDOUT = vIsLockedOut
		                   ,A.LASTLOCKOUTDATE = vLastLockoutDate
                      where a.USERID = vUserID
                        AND A.ISDELETED = 0;

        		end if;



        END IF;



  end;

 	-- Public function and procedure declarations
	procedure UnlockUser (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pUserId	in out NUMBER
	) as
		vApplicationID NUMBER;
		vUserID	NUMBER;
		vVerified VARCHAR2(1);
  begin
		PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
		vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);
		vVerified := VerifyUserApplication(vUserId,vApplicationID);

		if vVerified = 'S' THEN
    		update us_MEMBERSHIP a
		       SET a.ISLOCKEDOUT = 0
			     	,a.FAILEDPSWDATTEMPTCOUNT = 0
    				,a.FAILEDPSWDATTEMPTWINDOWSTART = sysdate
	       			,a.FAILEDPSWDANSATTEMPTCOUNT = 0
		      		,a.FAILEDPSWDANSATTEMPTWINSTART = sysdate
   			  where a.USERID = vUserID
                AND A.ISDELETED = 0;

    		pUserId := vUserID;
        END IF;
	end;

 	-- Public function and procedure declarations
	procedure UpdateUser (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
    pEmail VARCHAR2,
    pIsApproved  NUMBER default 0,
		pUpdateLastActivityDate NUMBER default 0,
		pUpdateLastLoginDate NUMBER default 0,
    pStatus in out NUMBER
	) as
		vApplicationID NUMBER;
		vUserID	NUMBER;
		vVerified VARCHAR2(1);
  begin
		PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
		vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);

		pStatus := 0;
		vVerified := VerifyUserApplication(vUserId,vApplicationID);

		if vVerified = 'S' THEN
    		update us_MEMBERSHIP a
	   		  SET A.ISAPPROVED = pIsApproved
			  	 ,A.EMAIL = pEmail
			 where a.USERID = vUserID
               AND A.ISDELETED = 0;

	       	pStatus := sql%rowcount;

            if (pUpdateLastActivityDate = 1) then
			     PR_US_MEMBERSHIP.SETLASTACTIVITYDATE(vUserId);
            end if;
            if (pUpdateLastLoginDate = 1) then
              PR_US_MEMBERSHIP.SETLASTLOGINDATE(vUserId);
            end if;
        END IF;
	end;

  -- Public function and procedure declarations
	procedure ChangePasswordQAndA (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pNewQuestion	VARCHAR2,
		pNewAnswer		VARCHAR2,
    pStatus in out NUMBER
	) as
		vApplicationID NUMBER;
		vUserID	NUMBER;
		vVerified VARCHAR2(1);
  begin
		PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
		vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);
    	vVerified := VerifyUserApplication(vUserId,vApplicationID);

		pStatus := 0;
		if vVerified = 'S' THEN
	   	   update us_MEMBERSHIP a
        		set PasswordQuestion = pNewQuestion,
		      	PasswordAnswer = pNewAnswer,
    			LastPasswordChangedDate = sysdate,
                FailedPswdAttemptCount = 0,
                FailedPswdAttemptWindowStart = sysdate,
                FailedPswdAnsAttemptCount = 0,
                FailedPswdAnsAttemptWinStart = sysdate
          	where a.USERID = vUserID
              AND A.ISDELETED = 0;

    		pStatus := sql%rowcount;
		END IF;
  end;

  -- Public function and procedure declarations
	procedure GetAllUsers (
    pResultSet  out curtype_MEMBERSHIP,
    pTotalRecords in out NUMBER,
		pApplicationName  VARCHAR2,
		pPageIndex		NUMBER default 1,
		pPageSize		NUMBER default 0
	) as
		vApplicationID NUMBER;
        vStartingRow NUMBER;
        vPageSize NUMBER;
  begin
	vPageSize := pPageSize;
    PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
    vStartingRow := (pPageIndex - 1) * pPageSize + 1;

    IF (vStartingRow < 0)THEN
        vStartingRow := 0;
    END IF;

    select count(b.USERID)
    into pTotalRecords
    from us_MEMBERSHIP_APPLICATION A, us_MEMBERSHIP b
    where A.userid        = B.userid
      AND A.APPLICATIONID = vApplicationID
      AND A.isdeleted = 0
      AND B.isdeleted = 0;

      IF (pPageSize = 0) THEN
        vStartingRow := 1;
        vPageSize    := pTotalRecords;
      END IF;

    open pResultSet for
      select *
      from (
        select rownum rnum,a.*
        from (
          select
            B.USERNAME
            ,B.EMAIL
            ,B.PASSWORDQUESTION
            ,B.ISAPPROVED
            ,B.CREATEDATE
            ,B.LASTLOGINDATE
            ,B.LASTACTIVITYDATE
            ,B.LASTPASSWORDCHANGEDDATE
            ,B.USERID
            ,B.ISLOCKEDOUT
            ,B.LASTLOCKOUTDATE
          from us_MEMBERSHIP_APPLICATION A, us_MEMBERSHIP b
          where A.userid    = B.userid
            AND A.APPLICATIONID = vApplicationID
            AND B.ISDELETED = 0
            AND A.isdeleted = 0
          order by b.USERNAME
        ) a
        where rownum < (vStartingRow + vPageSize)
      )
      where rnum >= vStartingRow
        and rnum < (rnum + vPageSize);
  end;

  -- Public function and procedure declarations
	function FGetAllUsers (
    pTotalRecords in out NUMBER,
		pApplicationName  VARCHAR2,
		pPageIndex		NUMBER default 1,
		pPageSize		NUMBER default 0
	) return curtype_MEMBERSHIP as
		vResultSet  curtype_MEMBERSHIP;
	begin
		GetAllUsers(vResultSet,pTotalRecords,pApplicationName,pPageIndex,pPageSize);
		return vResultSet;
	end;

  -- Public function and procedure declarations
	procedure GetNumberOfUsersOnline (
    pCount in out NUMBER,
		pApplicationName  VARCHAR2,
		pMinutesSinceLastInActive  NUMBER
	) as
    vLastActivityDate DATE;
		vApplicationID NUMBER;
  begin
		PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
    vLastActivityDate := sysdate - (1 / 24 / 60 * pMinutesSinceLastInActive);

    select count(B.LastActivityDate)
    into pCount
    from us_MEMBERSHIP_APPLICATION A, us_MEMBERSHIP b
    where A.userid            = B.userid
      and A.APPLICATIONID     = vApplicationID
      and B.LASTACTIVITYDATE >= vLastActivityDate
      AND B.ISDELETED = 0
      AND A.isdeleted = 0;
  end;

  -- Public function and procedure declarations
	procedure FindUsersByName (
    pResultSet  in out curtype_MEMBERSHIP,
    pTotalRecords in out NUMBER,
		pApplicationName  VARCHAR2,
		pUserNameToMatch	VARCHAR2 default '%%',
		pPageIndex		NUMBER default 1,
		pPageSize		NUMBER default 10
	) as
		vUserNameToMatch	VARCHAR2(4000);
    vStartingRow NUMBER;
		vApplicationID NUMBER;
  begin
		PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
    vStartingRow := (pPageIndex - 1) * pPageSize + 1;
    vUserNameToMatch := '%' || lower(trim(pUserNameToMatch)) || '%';

    select count(b.USERID)
    into pTotalRecords
    from us_MEMBERSHIP_APPLICATION A, us_MEMBERSHIP b
    where B.userid = A.userid
      AND A.APPLICATIONID = vApplicationID
      and lower(trim(b.USERNAME)) like vUserNameToMatch
      AND B.ISDELETED = 0
      AND A.isdeleted = 0;

    open pResultSet for
      select *
      from (
        select rownum rnum,a.*
        from (
          select
            B.USERNAME
            ,B.EMAIL
            ,B.PASSWORDQUESTION
            ,B.ISAPPROVED
            ,B.CREATEDATE
            ,B.LASTLOGINDATE
            ,B.LASTACTIVITYDATE
            ,B.LASTPASSWORDCHANGEDDATE
            ,B.USERID
            ,B.ISLOCKEDOUT
            ,B.LASTLOCKOUTDATE
          from us_MEMBERSHIP_APPLICATION A, us_MEMBERSHIP b
          whERE A.USERID        = B.USERID
            AND A.APPLICATIONID = vApplicationID
            AND B.ISDELETED     = 0
            AND A.isdeleted     = 0
          order by b.USERNAME
        ) a
        where lower(trim(a.USERNAME)) like vUserNameToMatch
        and rownum < (vStartingRow + pPageSize)
      )
      where rnum >= vStartingRow
      and rnum < (rnum + pPageSize);
  end;

  -- Public function and procedure declarations
	function FFindUsersByName (
    pTotalRecords in out NUMBER,
		pApplicationName  VARCHAR2,
		pUserNameToMatch	VARCHAR2 default '%%',
		pPageIndex		NUMBER default 1,
		pPageSize		NUMBER default 10
	) return curtype_MEMBERSHIP as
		vResultSet  curtype_MEMBERSHIP;
	begin
		FindUsersByName(vResultSet,pTotalRecords,pApplicationName,pUserNameToMatch,pPageIndex,pPageSize);
		return vResultSet;
	end;

  -- Public function and procedure declarations
	procedure FindUsersByEmail (
    pResultSet  in out curtype_MEMBERSHIP,
    pTotalRecords in out NUMBER,
		pApplicationName  VARCHAR2,
		pEmailToMatch	VARCHAR2 default '%%',
		pPageIndex		NUMBER default 1,
		pPageSize		NUMBER default 10
	) as
		vEmailToMatch	  VARCHAR2(4000);
        vStartingRow      NUMBER;
		vApplicationID    NUMBER;
		vApplicationAllow VARCHAR2(1);
  begin
	PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);

    vStartingRow := (pPageIndex - 1) * pPageSize + 1;
    vEmailToMatch := '%' || lower(trim(pEmailToMatch)) || '%';

    select count(b.USERID)
    into pTotalRecords
    from us_MEMBERSHIP_APPLICATION A, us_MEMBERSHIP b
    where B.userid = A.userid
      AND A.APPLICATIONID = vApplicationID
	  and lower(trim(b.EMAIL)) like vEmailToMatch
      AND B.ISDELETED = 0
      AND A.isdeleted = 0;

    open pResultSet for
      select *
      from (
        select rownum rnum,a.*
        from (
          select
            B.USERNAME
            ,B.EMAIL
            ,B.PASSWORDQUESTION
            ,B.ISAPPROVED
            ,B.CREATEDATE
            ,B.LASTLOGINDATE
            ,B.LASTACTIVITYDATE
            ,B.LASTPASSWORDCHANGEDDATE
            ,B.USERID
            ,B.ISLOCKEDOUT
            ,B.LASTLOCKOUTDATE
          from us_MEMBERSHIP_APPLICATION A, us_MEMBERSHIP b
          where A.USERID        = B.USERID
            AND A.APPLICATIONID = vApplicationID
            AND B.ISDELETED = 0
            AND A.isdeleted = 0
          order by b.EMAIL
        ) a
        where lower(trim(a.EMAIL)) like vEmailToMatch
        and rownum < (vStartingRow + pPageSize)
      )
      where rnum >= vStartingRow
      and rnum < (rnum + pPageSize);
  end;

  -- Public function and procedure declarations
	function FFindUsersByEmail (
    pTotalRecords in out NUMBER,
		pApplicationName  VARCHAR2,
		pEmailToMatch	VARCHAR2 default '%%',
		pPageIndex		NUMBER default 1,
		pPageSize		NUMBER default 10
	) return curtype_MEMBERSHIP as
		vResultSet  curtype_MEMBERSHIP;
	begin
		FindUsersByEmail(vResultSet,pTotalRecords,pApplicationName,pEmailToMatch,pPageIndex,pPageSize);
		return vResultSet;
	end;

  -- Public function and procedure declarations
	procedure DeleteUser (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
        pStatus in out NUMBER
	) as
		vApplicationID NUMBER;
		vUserId        NUMBER;
  begin
		PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);


        SELECT UserId
          INTO vUserId
          FROM us_MEMBERSHIP
         WHERE lower(trim(USERNAME)) = lower(trim(pUserName))
           AND ISDELETED = 0;

        BEGIN
		  /*delete from us_MEMBERSHIP a
		        where a.APPLICATIONID = vApplicationID
                  and lower(trim(USERNAME)) = lower(trim(pUserName));
          */
          UPDATE us_MEMBERSHIP SET ISDELETED = 1
           WHERE USERID = vUserId;

          DeleteUserAllApplication(vUserId);

          pStatus := sql%rowcount;

          COMMIT;
        EXCEPTION WHEN OTHERS THEN
            ROLLBACK;
        END;


  end;










/*


  -- Public function and procedure declarations
  -- updates the user email value
	procedure UpdateUserEmail (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pEmail		VARCHAR2
	) as
		vApplicationID NUMBER;
  begin
		APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);

		update us_MEMBERSHIP a
		set Email = pEmail
		where a.APPLICATIONID = vApplicationID
    and lower(trim(a.USERNAME)) = lower(trim(pUserName));
  end;

  -- Public function and procedure declarations
  -- identifes that the user is authenticated
	procedure UserAuthenticated (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2
	) as
		vApplicationID NUMBER;
  begin
		APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);

		update us_MEMBERSHIP a
		set IsLockedOut = 0,
      FailedPswdAttemptCount = 0,
      FailedPswdAttemptWindowStart = sysdate,
      FailedPswdAnsAttemptCount = 0,
      FailedPswdAnsAttemptWinStart = sysdate,
      LastLoginDate = sysdate
		where a.APPLICATIONID = vApplicationID
    and lower(trim(a.USERNAME)) = lower(trim(pUserName));
  end;

 	-- Public function and procedure declarations
	procedure UpdateUserLogonInfo (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
    pIsApproved NUMBER,
    pIsLockedOut  NUMBER,
    pFailedPswdAttemptCount  NUMBER,
    pSetPswdAttemptWindowStart  DATE DEFAULT SYSDATE,
    pFailedPswdAnsAttemptCount  NUMBER,
    pSetPswdAnsAttemptWinStart  DATE DEFAULT SYSDATE
	) as
		vApplicationID NUMBER;
  begin
		APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);

		update us_MEMBERSHIP a
		set IsApproved = pIsApproved,
			IsLockedOut = pIsLockedOut,
      FailedPswdAttemptCount = pFailedPswdAttemptCount,
      FailedPswdAttemptWindowStart = decode(pSetPswdAttemptWindowStart,'Y',sysdate,FailedPswdAttemptWindowStart),
      FailedPswdAnsAttemptCount = pFailedPswdAnsAttemptCount,
      FailedPswdAnsAttemptWinStart = decode(pSetPswdAnsAttemptWinStart,'Y',sysdate,FailedPswdAnsAttemptWinStart)
		where a.APPLICATIONID = vApplicationID
    and lower(trim(a.USERNAME)) = lower(trim(pUserName));
 end;

  -- Public function and procedure declarations
	procedure FindUsersByEmailCount (
    pCount in out NUMBER,
		pApplicationName  VARCHAR2,
		pEmailToMatch	VARCHAR2 default '%%'
	) as
		vEmailToMatch	VARCHAR2(4000);
		vApplicationID NUMBER;
  begin
		APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
    vEmailToMatch := '%' || lower(trim(pEmailToMatch)) || '%';

    select count(*)
    into pCount
    from us_MEMBERSHIP a
    where a.APPLICATIONID = vApplicationID
    and lower(trim(a.EMAIL)) like vEmailToMatch;
  end;

  -- Public function and procedure declarations
	procedure FindUsersByUserNameCount (
    pCount in out NUMBER,
		pApplicationName  VARCHAR2,
		pUserNameToMatch	VARCHAR2 default '%%'
	) as
		vUserNameToMatch	VARCHAR2(4000);
		vApplicationID NUMBER;
  begin
		APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
    vUserNameToMatch := '%' || lower(trim(pUserNameToMatch)) || '%';

    select count(*)
    into pCount
    from us_MEMBERSHIP b
    where b.APPLICATIONID = vApplicationID
    and lower(trim(b.USERNAME)) like vUserNameToMatch;
  end;

  -- Public function and procedure declarations
	procedure GetUsersCount (
    pCount in out NUMBER,
		pApplicationName  VARCHAR2
	) as
		vApplicationID NUMBER;
  begin
		APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);

    select count(*)
    into pCount
    from us_MEMBERSHIP b
    where b.APPLICATIONID = vApplicationID;
  end;

  ApplicationId                          number not null,
  UserId                                 number not null,
  LastActivityDate 											 date default sysdate not null,
  UserName         											 varchar2(256) not null,
  *Password                               varchar2(128) not null,
  *PasswordFormat                         number not null,
  *PasswordSalt                           varchar2(128) not null,
  *PasswordQuestion                       varchar2(256) not null,
  *PasswordAnswer                         varchar2(128) not null,
  *CreateDate                             date default sysdate not null,
  Email                                  varchar2(256) not null,
  IsApproved                             number default 0 not null,
  IsLockedOut                            number default 0 not null,
  LastLoginDate                          date default sysdate not null,
  LastPasswordChangedDate                date default sysdate not null,
  LastLockoutDate                        date default sysdate not null,
  FailedPswdAttemptCount                 number default 0 not null,
  FailedPswdAttemptWindowStart           date default sysdate not null,
  FailedPswdAnsAttemptCount              number default 0 not null,
  FailedPswdAnsAttemptWinStart           date default sysdate not null,
*/

    PROCEDURE InsertUserApplication(pUserId IN NUMBER, pApplicationID NUMBER)
    IS
    BEGIN
		INSERT INTO us_MEMBERSHIP_APPLICATION (APPLICATIONID,USERID,ISDELETED)
		VALUES (pApplicationID,pUserId,0);
    EXCEPTION
       WHEN DUP_VAL_ON_INDEX THEN
          NULL;
    END;

    PROCEDURE DeleteUserApplication(pUserId IN NUMBER, pApplicationID NUMBER)
    IS
    BEGIN
		DELETE FROM us_MEMBERSHIP_APPLICATION
              WHERE APPLICATIONID = pApplicationID
                AND USERID        = pUserId;
    END;

    PROCEDURE DeleteUserAllApplication(pUserId IN NUMBER)
    IS
    BEGIN
		DELETE FROM us_MEMBERSHIP_APPLICATION
              WHERE USERID = pUserId;
    END;

    FUNCTION VerifyUserApplication (pUserId IN NUMBER, pApplicationID NUMBER)
    RETURN VARCHAR2
    IS
    vVerified VARCHAR2(1) := 'N';
    BEGIN
        BEGIN
            SELECT 'S'
              INTO vVerified
              FROM us_MEMBERSHIP_APPLICATION
              WHERE APPLICATIONID = pApplicationID
                AND USERID        = pUserId;
        EXCEPTION WHEN NO_DATA_FOUND then
            vVerified := 'N';
        END;
        return vVerified;
    END;

    FUNCTION VerifyUserNameApplicationName (pUserName IN VARCHAR2, pApplicationName VARCHAR2)
    RETURN VARCHAR2
    IS
    vVerified VARCHAR2(1) := 'N';
    vApplicationID NUMBER;
    vUserID	NUMBER;
    BEGIN
        BEGIN
        PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
        vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);
            SELECT 'S'
              INTO vVerified
              FROM us_MEMBERSHIP_APPLICATION
              WHERE APPLICATIONID = vApplicationID
                AND USERID        = vUserID
                AND ISDELETED      = 0;
        EXCEPTION WHEN NO_DATA_FOUND then
            vVerified := 'N';
        END;
        return vVerified;
    END;


   	procedure UpdateUserExtraInfo (
		pApplicationName  VARCHAR2,
        pUserName         VARCHAR2,
        pFirstName        VARCHAR2,
        pLastName         VARCHAR2,
        pTipoId           VARCHAR2,
        pNumId            NUMBER
	) as
		vApplicationID NUMBER;
		vUserId        NUMBER;
	BEGIN
	   	PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
		vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);

        UPDATE us_MEMBERSHIP
           SET TIPOID = pTipoId,
               NUMID  = pNumId,
               FIRSTNAME = pFirstName,
               LASTNAME = pLastName
         WHERE UserId = vUserId;

	END;

   	procedure GetUserExtraInfo (
   	    pResultSet  in out curtype_MEMBERSHIP,
		pApplicationName  VARCHAR2,
        pUserName         VARCHAR2
   	) as
		vApplicationID NUMBER;
		vUserId        NUMBER;
	BEGIN
	    BEGIN
    	   	PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
	   	EXCEPTION when no_data_found then
	   	   vApplicationID := 0;
	   	end;

        BEGIN
    		vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);
	   	EXCEPTION when no_data_found then
	   	   vUserId := 0;
	   	end;

		OPEN pResultSet FOR
            select TIPOID,NUMID,FIRSTNAME,LASTNAME
              FROM us_MEMBERSHIP
             WHERE UserId = vUserId;

	END;

    -- Public function and procedure declarations
	procedure AssociateUserToApplication (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pUserId	out NUMBER
	) as
		vApplicationID NUMBER;
		vUserID	NUMBER;
		vVerified VARCHAR2(1);
  begin
		PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
		vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);
		vVerified := VerifyUserApplication(vUserId,vApplicationID);

        UPDATE us_MEMBERSHIP_APPLICATION a
        SET ISDELETED = 0
        WHERE applicationid = vApplicationID
        AND   userid        = vUserID;

        pUserId := vUserID;
	end;

    -- Public function and procedure declarations
	procedure DisassociatesUserToApplication (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
		pUserId	out NUMBER
	) as
		vApplicationID NUMBER;
		vUserID	NUMBER;
		vVerified VARCHAR2(1);
  begin
		PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
		vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);
		vVerified := VerifyUserApplication(vUserId,vApplicationID);

        UPDATE us_MEMBERSHIP_APPLICATION a
        SET ISDELETED = 1
        WHERE applicationid = vApplicationID
        AND   userid        = vUserID;

        pUserId := vUserID;
	end;

  FUNCTION FGetFullName(vusername IN VARCHAR2) RETURN VARCHAR2 IS
    vnomusr varchar2(257); -- firstname + espacio + lastname
  BEGIN
    SELECT u.firstname || ' ' || u.lastname
        INTO vnomusr
    FROM usprovider.us_membership u WHERE u.username = vusername;

    RETURN(vnomusr);
  END FGetFullName;
end pr_us_membership;
-- END PL/SQL BLOCK (do not remove this line) ----------------------------------
/


-- End of DDL Script for Package USPROVIDER.PR_US_MEMBERSHIP

