-- Start of DDL Script for Package USPROVIDER.PR_US_ROLES
-- Generated 28-Feb-2011 10:50:34 from USPROVIDER@COPIAPRE.world

CREATE OR REPLACE 
PACKAGE pr_us_roles is

  -- Author  : ROGER.ROWE
  -- Created : 28-Nov-06 8:58:39 AM
  -- Purpose : Support the Roles

  -- Public type declarations
	-- ** identifies procedures that
	type curtype_ROLES is ref cursor;
  -- Private type declarations

  -- Public function and procedure declarations
	-- internal
	function GetRoleId (
		pApplicationID	NUMBER,
		pRoleName		VARCHAR2
	) return NUMBER;

	-- =================================================
	-- =================================================

 	-- Public function and procedure declarations
	procedure IsUserInRole (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
    pRoleName VARCHAR2,
    pStatus in out NUMBER
	);

 	-- Public function and procedure declarations
	procedure GetRolesForUser (
    pResultSet   out curtype_ROLES,
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
    pStatus  out NUMBER
	);

 	-- Public function and procedure declarations
	function FGetRolesForUser (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
    pStatus in out NUMBER
	) return curtype_ROLES;

 	-- Public function and procedure declarations
	procedure CreateRole (
		pApplicationName  VARCHAR2,
    pRoleName VARCHAR2,
    pDescription VARCHAR2 default null,
		pRoleID in out NUMBER,
    pStatus in out NUMBER
	);

 	-- Public function and procedure declarations
	procedure DeleteRole (
		pApplicationName  VARCHAR2,
    pRoleName VARCHAR2,
    pDeleteOnlyIfRoleIsEmpty NUMBER default 1,
    pStatus in out NUMBER
	);

 	-- Public function and procedure declarations
	procedure RoleExists (
		pRoleID in out NUMBER,
		pApplicationName  VARCHAR2,
    pRoleName VARCHAR2,
    pStatus in out NUMBER
	);

 	-- Public function and procedure declarations
	procedure AddUserToRole (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
    pRoleName VARCHAR2,
    pStatus in out NUMBER
	);

 	-- Public function and procedure declarations
	procedure RemoveUserFromRole (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
    pRoleName VARCHAR2,
    pStatus in out NUMBER
	);

 	-- Public function and procedure declarations
	procedure GetUsersInRole (
    pResultSet  in out curtype_ROLES,
		pApplicationName  VARCHAR2,
    pRoleName VARCHAR2,
    pStatus in out NUMBER
	);

 	-- Public function and procedure declarations
	function FGetUsersInRole (
		pApplicationName  VARCHAR2,
    pRoleName VARCHAR2,
    pStatus in out NUMBER
	) return curtype_ROLES;

 	-- Public function and procedure declarations
	procedure FindUsersInRole (
    pResultSet  in out curtype_ROLES,
		pApplicationName  VARCHAR2,
    pRoleName VARCHAR2,
    pUserNameToMatch VARCHAR2 default '%%',
    pStatus in out NUMBER
	);

 	-- Public function and procedure declarations
	function FFindUsersInRole (
		pApplicationName  VARCHAR2,
    pRoleName VARCHAR2,
    pUserNameToMatch VARCHAR2 default '%%',
    pStatus in out NUMBER
	) return curtype_ROLES;

 	-- Public function and procedure declarations
	procedure GetAllRoles (
    pResultSet  out curtype_ROLES,
		pApplicationName  VARCHAR2,
    pStatus out NUMBER
	);

 	-- Public function and procedure declarations
	function FGetAllRoles (
		pApplicationName  VARCHAR2,
    pStatus in out NUMBER
	) return curtype_ROLES;



end pr_us_ROLES;
-- END PL/SQL BLOCK (do not remove this line) ----------------------------------
/


CREATE OR REPLACE 
PACKAGE BODY pr_us_roles  is

  -- Private type declarations
--	type myTableType is table of varchar2(256);
/*
	-- Private function and procedure declarations
	function in_list( p_string in varchar2 ) return myTableType as
		l_string        long default p_string || ',';
		l_data          myTableType := myTableType();
		n               number;
	begin
		loop
			exit when l_string is null;
			n := instr( l_string, ',' );
			l_data.extend;
			l_data(l_data.count) := ltrim( rtrim( substr( l_string, 1, n-1 ) ) );
			l_string := substr( l_string, n+1 );
		end loop;

		return l_data;
	end;
*/
	-- =================================================
	-- =================================================

    -- Public function and procedure declarations
    -- internal
    function GetRoleId (
        pApplicationID	NUMBER,
        pRoleName		VARCHAR2
    ) return NUMBER as
        vRoleID	NUMBER;
    begin
        select /*+ FIRST_ROWS */ a.ROLEID
      	into vRoleID
        from us_ROLES a
        where a.APPLICATIONID = pApplicationID
          and lower(trim(a.ROLENAME)) = lower(trim(pRoleName));

        return vRoleID;
    end;

	-- =================================================
	-- =================================================

 	-- Public function and procedure declarations
	procedure IsUserInRole (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
    pRoleName VARCHAR2,
    pStatus in out NUMBER
	) as
		vApplicationID NUMBER;
		vUserID	NUMBER;
		vRoleID	NUMBER;
  begin
    pStatus := 0;
    begin
      PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
    exception
      when no_data_found then
        pStatus := -21;
        return;
    end;

    begin
      vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);
    exception
      when no_data_found then
        pStatus := -22;
        return;
    end;

    begin
      vRoleID := PR_US_ROLES.GETROLEID(vApplicationID,pRoleName);
    exception
      when no_data_found then
        pStatus := -23;
        return;
    end;

		select count(a.USERID)
		into pStatus
		from us_USERSINROLES a
		where a.USERID = vUserID
		and a.ROLEID = vRoleID;
	end;

 	-- Public function and procedure declarations
	procedure GetRolesForUser (
    pResultSet   out curtype_ROLES,
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
    pStatus  out NUMBER
	) as
		vApplicationID NUMBER;
		vUserID	NUMBER;
  begin
    pStatus := 0;
    begin
      PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
    exception
      when no_data_found then
        pStatus := -31;
        return;
    end;

    begin
      vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);
    exception
      when no_data_found then
        pStatus := -32;
        return;
    end;

		select count(a.ROLENAME)
		into pStatus
		from us_ROLES a
			,us_USERSINROLES b
		where a.APPLICATIONID = vApplicationID
		and a.ROLEID = b.ROLEID
		and b.USERID = vUserID;

		-- status represents the number of roles
        -- no need to run query if we know there are none
/*		if (pStatus = 0) then

			return;
        else

        end if;*/

        open pResultSet for
        			select a.ROLENAME
        			from us_ROLES a
        				,us_USERSINROLES b
        			where a.APPLICATIONID = vApplicationID
        			and a.ROLEID = b.ROLEID
        			and b.USERID = vUserID
        			order by 1;

	end;

 	-- Public function and procedure declarations
	function FGetRolesForUser (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
    pStatus in out NUMBER
	) return curtype_ROLES as
    vResultSet curtype_ROLES;
  begin
    GetRolesForUser(vResultSet,pApplicationName,pUserName,pStatus);
    return vResultSet;
  end;

 	-- Public function and procedure declarations
	procedure CreateRole (
		pApplicationName  VARCHAR2,
    pRoleName VARCHAR2,
    pDescription VARCHAR2 default null,
		pRoleID in out NUMBER,
    pStatus in out NUMBER
	) as
		vApplicationID NUMBER;
  begin
    pStatus := 0;
    begin
      PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
    exception
      when no_data_found then
        pStatus := -41;
        return;
    end;

    begin
  		insert into us_ROLES
  			(
  				APPLICATIONID
  				,ROLENAME
  				,DESCRIPTION
  			) values (
  				vApplicationID
  				,pRoleName
  				,pDescription
  			) returning ROLEID into pRoleID;

      pStatus := sql%rowcount;
    exception
      when dup_val_on_index then
        pStatus := -42;
    end;

	end;

 	-- Public function and procedure declarations
	procedure DeleteRole (
		pApplicationName  VARCHAR2,
    pRoleName VARCHAR2,
    pDeleteOnlyIfRoleIsEmpty NUMBER default 1,
    pStatus in out NUMBER
	) as
		vApplicationID NUMBER;
		vRoleID	NUMBER;
		vRowCount	NUMBER;
  begin
    pStatus := 0;
    begin
      PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
    exception
      when no_data_found then
        pStatus := -51;
        return;
    end;

    begin
      vRoleID := PR_US_ROLES.GETROLEID(vApplicationID,pRoleName);
    exception
      when no_data_found then
        pStatus := -52;
        return;
    end;

		if (pDeleteOnlyIfRoleIsEmpty = 1) then
  		select count(a.USERID)
  		into vRowCount
  		from us_USERSINROLES a
  		where a.ROLEID = vRoleID;

			if (vRowCount > 0) then
				pStatus := -53;
				return;
			end if;
		end if;

		delete from us_ROLES a
		where A.ROLEID = vRoleID;

		-- provides number of rows deleted.
		pStatus := sql%rowcount;
	end;

 	-- Public function and procedure declarations
	procedure RoleExists (
        pRoleID in out      NUMBER,
        pApplicationName    VARCHAR2,
        pRoleName           VARCHAR2,
        pStatus in out      NUMBER
	) as
		vApplicationID NUMBER;
    begin
        pStatus := 0;

        begin
            PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
        exception
            when no_data_found then
                pStatus := -61;
                return;
        end;

    	begin
            pRoleID := PR_US_ROLES.GETROLEID(vApplicationID,pRoleName);
    	exception
            when no_data_found then
                pStatus := -62;
    	end;

    end;

 	-- Public function and procedure declarations
	procedure AddUserToRole (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
    pRoleName VARCHAR2,
    pStatus in out NUMBER
	) as
		vApplicationID NUMBER;
		vUserID	NUMBER;
		vRoleID	NUMBER;
  begin
    pStatus := 0;
    begin
      PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
    exception
      when no_data_found then
        pStatus := -71;
        return;
    end;

    begin
      vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);
    exception
      when no_data_found then
        pStatus := -72;
        return;
    end;

    begin
      vRoleID := PR_US_ROLES.GetRoleId(vApplicationID,pRoleName);
    exception
      when no_data_found then
        pStatus := -73;
        return;
    end;

    begin
  		insert into us_USERSINROLES
  			(
  				USERID
  				,ROLEID
  			) values (
          vUserID
          ,vRoleID
        );

  		pStatus := sql%rowcount;

    exception
      when dup_val_on_index then
        pStatus := -74;
    end;

	end;

 	-- Public function and procedure declarations
	procedure RemoveUserFromRole (
		pApplicationName  VARCHAR2,
		pUserName  VARCHAR2,
    pRoleName VARCHAR2,
    pStatus in out NUMBER
	) as
		vApplicationID NUMBER;
		vUserID	NUMBER;
		vRoleID	NUMBER;
  begin
    pStatus := 0;
    begin
      PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
    exception
      when no_data_found then
        pStatus := -81;
        return;
    end;

    begin
      vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID,pUserName);
    exception
      when no_data_found then
        pStatus := -82;
        return;
    end;

    begin
      vRoleID := PR_US_ROLES.GetRoleId(vApplicationID,pRoleName);
    exception
      when no_data_found then
        pStatus := -83;
        return;
    end;

    delete from us_USERSINROLES a
    where A.USERID = vUserID
    and A.ROLEID = vRoleID;

  	pStatus := sql%rowcount;
  end;

 	-- Public function and procedure declarations
	procedure GetUsersInRole (
        pResultSet  in out  curtype_ROLES,
        pApplicationName    VARCHAR2,
        pRoleName           VARCHAR2,
        pStatus in out      NUMBER
	) as
		vApplicationID    NUMBER;
		vRoleID	          NUMBER;
		vError            NUMBER := 0;
    begin
        pStatus := 0;
        begin
            PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
        exception
            when no_data_found then
                pStatus := -91;
                vError := 1;
        end;

        begin
            vRoleID := PR_US_ROLES.GetRoleId(vApplicationID,pRoleName);
        exception
            when no_data_found then
                pStatus := -92;
                vError := 1;
        end;

        IF (vError = 0)THEN
            select count(A.USERNAME)
              into pStatus
              from us_MEMBERSHIP a,
                   us_USERSINROLES b
              where A.USERID = B.USERID
                and B.ROLEID = vRoleID;
        
        
            -- status represents the number of users
            -- no need to run query if we know there are none
            if (pStatus = 0) then
              vError := 1;
            end if;

            IF (vError = 0)THEN
                open pResultSet for
                    select A.USERNAME
                      from us_MEMBERSHIP a,
                           us_USERSINROLES b
                     where A.USERID = B.USERID
                       and B.ROLEID = vRoleID
                        order by 1;

                pStatus := sql%rowcount;
            END IF;
        END IF;
    end;

 	-- Public function and procedure declarations
	function FGetUsersInRole (
		pApplicationName  VARCHAR2,
    pRoleName VARCHAR2,
    pStatus in out NUMBER
	) return curtype_ROLES as
    vResultSet curtype_ROLES;
  begin
    GetUsersInRole(vResultSet,pApplicationName,pRoleName,pStatus);
    return vResultSet;
  end;

 	-- Public function and procedure declarations
	procedure FindUsersInRole (
    pResultSet  in out curtype_ROLES,
		pApplicationName  VARCHAR2,
    pRoleName VARCHAR2,
    pUserNameToMatch VARCHAR2 default '%%',
    pStatus in out NUMBER
	) as
		vUserNameToMatch	VARCHAR2(4000);
		vApplicationID NUMBER;
		vRoleID	NUMBER;
  begin
    pStatus := 0;
    begin
      PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
    exception
      when no_data_found then
        pStatus := -101;
        return;
    end;

    begin
      vRoleID := PR_US_ROLES.GetRoleId(vApplicationID,pRoleName);
    exception
      when no_data_found then
        pStatus := -102;
        return;
    end;

    vUserNameToMatch := '%' || lower(trim(pUserNameToMatch)) || '%';

		select count(A.USERNAME)
		into pStatus
  	from us_MEMBERSHIP_APPLICATION M,
         us_MEMBERSHIP a
  		,us_USERSINROLES b
  	where M.APPLICATIONID = vApplicationID
	  AND M.userid = B.userid
	  and M.isdeleted = 0
	  and A.USERID = B.USERID
  	  and B.ROLEID = vRoleID
      and lower(trim(A.USERNAME)) like vUserNameToMatch;

		-- status represents the number of users
    -- no need to run query if we know there are none
		if (pStatus = 0) then
			return;
		end if;

    open pResultSet for
			select A.USERNAME
			from us_MEMBERSHIP_APPLICATION M,
                 us_MEMBERSHIP a
				,us_USERSINROLES b
			where M.APPLICATIONID = vApplicationID
			AND M.userid = B.userid
			and M.isdeleted = 0
			and A.USERID = B.USERID
			and B.ROLEID = vRoleID
      and lower(trim(A.USERNAME)) like vUserNameToMatch
			order by 1;

  end;

 	-- Public function and procedure declarations
	function FFindUsersInRole (
		pApplicationName  VARCHAR2,
    pRoleName VARCHAR2,
    pUserNameToMatch VARCHAR2 default '%%',
    pStatus in out NUMBER
	) return curtype_ROLES as
    vResultSet curtype_ROLES;
  begin
    FindUsersInRole(vResultSet,pApplicationName,pRoleName,pUserNameToMatch,pStatus);
    return vResultSet;
  end;

    -- Public function and procedure declarations
    procedure GetAllRoles (
        pResultSet  out curtype_ROLES,
        pApplicationName  VARCHAR2,
        pStatus out NUMBER
    ) as
        vApplicationID NUMBER;
    begin
        pStatus := 0;
        begin
            PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID,pApplicationName);
        exception
            when no_data_found then
                pStatus := -111;
                return;
        end;

        select count(A.ROLENAME)
        into pStatus
        from us_ROLES A
        where A.APPLICATIONID = vApplicationID;

        -- status represents the number of users
        -- no need to run query if we know there are none
        if (pStatus = 0) then
            return;
        end if;

        open pResultSet for
            select A.ROLENAME
            from us_ROLES A
            where a.APPLICATIONID = vApplicationID
            order by 1;

        --pStatus := sql%rowcount;

    end;

 	-- Public function and procedure declarations
	function FGetAllRoles (
		pApplicationName  VARCHAR2,
    pStatus in out NUMBER
	) return curtype_ROLES as
    vResultSet curtype_ROLES;
  begin
    GetAllRoles(vResultSet,pApplicationName,pStatus);
    return vResultSet;
  end;

end pr_us_ROLES;
-- END PL/SQL BLOCK (do not remove this line) ----------------------------------
/


-- End of DDL Script for Package USPROVIDER.PR_US_ROLES

