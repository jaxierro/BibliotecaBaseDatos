-- Start of DDL Script for Package USPROVIDER.PR_US_PROFILE
-- Generated 28-Feb-2011 10:50:26 from USPROVIDER@COPIAPRE.world

CREATE OR REPLACE 
PACKAGE pr_us_profile
  IS

  -- Public type declarations
    type curtype_PROFILE is ref cursor;

    -- Public function and procedure declarations
    procedure DeleteInactiveProfiles (
        pApplicationName    VARCHAR2,
        pProfileAuthOptions NUMBER,
        pInactiveSinceDate  DATE,
        pStatus in out NUMBER
    );


    -- Public function and procedure declarations
    procedure DeleteProfiles (
        pApplicationName    VARCHAR2,
        pUserNames          VARCHAR2,
        pStatus in out      NUMBER
    );


    -- Public function and procedure declarations
    function GetNumberOfInactiveProfiles (
        pApplicationName    VARCHAR2,
        pProfileAuthOptions NUMBER,
        pInactiveSinceDate  DATE
    ) return NUMBER;


    -- Public function and procedure declarations
    procedure GetProfiles (
        pResultSet  in out      curtype_PROFILE,
        pTotalRecords in out    NUMBER,
        pApplicationName        VARCHAR2,
        pProfileAuthOptions     NUMBER,
        pPageIndex              NUMBER default 1,
        pPageSize               NUMBER default 10,
        pUserNameToMatch        VARCHAR2 default null,
        pInactiveSinceDate      DATE default null
    );

    -- Public function and procedure declarations
    procedure GetProperties (
        pResultSet  in out curtype_PROFILE,
        pApplicationName    VARCHAR2,
        pUserName           VARCHAR2
    );


    -- Public function and procedure declarations
    procedure SetProperties (
        pApplicationName        VARCHAR2,
        pPropertyName           VARCHAR2,
        pPropertyValue          VARCHAR2,
        pPropertyType           VARCHAR2,
        pUserName               VARCHAR2,
        pIsUserAnonymous        NUMBER
    );


    -- Public function and procedure declarations
    -- internal
    procedure SetLastUpdatedDate (
        pApplicationID  NUMBER,
        pUserID  NUMBER
    );

    procedure GetProperty (
        pResultSet  in out curtype_PROFILE,
        pApplicationName    VARCHAR2,
        pPropertyName       VARCHAR2,
        pUserName           VARCHAR2
    );

    function GetDecodedProperty (
        pApplicationName    VARCHAR2,
        pPropertyName       VARCHAR2,
        pUserName           VARCHAR2
    ) return TblData PIPELINED;
END; -- Package spec
-- END PL/SQL BLOCK (do not remove this line) ----------------------------------
/


CREATE OR REPLACE 
PACKAGE BODY              pr_us_profile 
IS

    -- Public function and procedure declarations
    procedure DeleteInactiveProfiles (
        pApplicationName    VARCHAR2,
        pProfileAuthOptions NUMBER,
        pInactiveSinceDate  DATE,
        pStatus in out NUMBER
    ) as
    	vApplicationID NUMBER;
    begin
        PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID, pApplicationName);

    	delete from us_PROFILE p
    	where p.userid in
        (
            select m.userid
              from us_MEMBERSHIP_APPLICATION A, us_MEMBERSHIP m
             where A.userid = m.userid
               and a.applicationid = vApplicationID
               and (m.lastactivitydate <= pInactiveSinceDate)
               and a.isdeleted=0
                  /*  and (  -- El campo IsAnonymous no se encuentra en el modelo
                            (pProfileAuthOptions = 2)
                            or (pProfileAuthOptions = 0 and m.IsAnonymous = 1)
                            or (pProfileAuthOptions = 1 and m.IsAnonymous = 2)
                        ) */
        )
        and p.applicationid = vApplicationID;

    	pStatus := sql%rowcount;
    end;


    -- Public function and procedure declarations
    procedure DeleteProfiles (
        pApplicationName    VARCHAR2,
        pUserNames          VARCHAR2,
        pStatus in out      NUMBER
    ) as
        vApplicationID  NUMBER;
        vUserName       VARCHAR2(256);
        vCurrentPos     NUMBER;
        vNextPos        NUMBER;
        vNumDeleted     NUMBER;
        vErrorCode      NUMBER;
    begin
        vErrorCode := 0;
        vCurrentPos := 1;
        vNumDeleted := 0;

        begin
            PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID, pApplicationName);
        exception
            when no_data_found then
                pStatus := -21; -- TODO: revisar !!!
                return;
        end;

        begin
            while (vCurrentPos <= length(pUserNames))
            loop
                vNextPos := instr(pUserNames, ',', vCurrentPos);

                if (vNextPos = 0 or vNextPos is null) then
                    vNextPos := length(pUserNames) + 1;
                end if;

                vUserName := substr(pUserNames, vCurrentPos, vNextPos - vCurrentPos);
                vCurrentPos := vNextPos + 1;

                if (length(vUserName) > 0) then
                    delete from us_PROFILE p
                    where p.userid        = PR_US_MEMBERSHIP.GETUSERID(vApplicationID, vUserName)
                      AND p.applicationid = vApplicationID;

                    if (sql%rowcount <> 0) then
                        vNumDeleted := vNumDeleted + 1;
                    end if;
                end if;
            end loop;
        exception
            when others then
                pStatus := sqlcode; -- TODO: revisar !!!
              	rollback;
                return;
        end;

        pStatus := vNumDeleted;
        commit;
    end;


    -- Public function and procedure declarations
    function GetNumberOfInactiveProfiles (
        pApplicationName    VARCHAR2,
        pProfileAuthOptions NUMBER,
        pInactiveSinceDate  DATE
    ) return NUMBER as
    	vApplicationID NUMBER;
    	vNumberOfInactiveProfiles NUMBER;
    begin
        begin
            PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID, pApplicationName);
        exception
            when no_data_found then
                return -1; -- TODO: revisar !!!
        end;

        select count(*)
          into vNumberOfInactiveProfiles
          from us_membership_application a, us_membership m, us_profile p
          where (a.userid            = m.userid)
            and (a.applicationid     = vApplicationID)
            and (p.applicationid     = vApplicationID)
            and (m.userid            = p.userid)
            and (m.lastactivitydate <= pInactiveSinceDate)
            and (a.isdeleted         = 0);
          /*
            and (  -- El campo IsAnonymous no se encuentra en el modelo
                    (pProfileAuthOptions = 2)
                    or (pProfileAuthOptions = 0 and m.IsAnonymous = 1)
                    or (pProfileAuthOptions = 1 and m.IsAnonymous = 2)
                )
          */

        return vNumberOfInactiveProfiles;
    end;


    -- Public function and procedure declarations
    procedure GetProfiles (
        pResultSet  in out      curtype_PROFILE,
        pTotalRecords in out    NUMBER,
        pApplicationName        VARCHAR2,
        pProfileAuthOptions     NUMBER,
        pPageIndex              NUMBER default 1,
        pPageSize               NUMBER default 10,
        pUserNameToMatch        VARCHAR2 default null,
        pInactiveSinceDate      DATE default null
    ) as
        vApplicationID  NUMBER;
        vPageLowerBound NUMBER;
        vPageUpperBound NUMBER;
        vTotalRecords   NUMBER;
    begin
        begin
            PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID, pApplicationName);
        exception
            when no_data_found then
                return;
        end;

        -- Calculate pTotalRecords
        select count(m.userid)
          into pTotalRecords
          from us_membership_application a, us_membership m, us_profile p
         where a.userid = m.userid
           and a.applicationid = vApplicationID
           and p.applicationid = vApplicationID
           and m.userid = p.userid
           and (pInactiveSinceDate is null or m.LastActivityDate <= pInactiveSinceDate)
           and (pUserNameToMatch is null or lower(m.username) like lower(pUserNameToMatch))
           and (a.isdeleted = 0);
        -- and     (     (pProfileAuthOptions = 2)
        --            or (pProfileAuthOptions = 0 and IsAnonymous = 1)
        --            or (pProfileAuthOptions = 1 and IsAnonymous = 0)
        --         )

        -- Set the page bounds
        vPageLowerBound := pPageSize * pPageIndex;
        vPageUpperBound := pPageSize - 1 + vPageLowerBound;

        -- Fill the cursor
        open pResultSet for
        select * from (
            select rownum rnum, a.* from (
                select  m.username, m.lastactivitydate, p.lastupdateddate,
                        --lengthb(p.propertynames) + lengthb(p.propertyvaluesstring) + lengthb(p.propertyvaluesbinary) len
                        lengthb(p.propertyname) + lengthb(p.propertyvalue) + lengthb(p.propertytype) len
                from    us_membership_application a, us_membership m, us_profile p
                where   a.userid = m.userid
                and     a.applicationid = vApplicationID
                and     p.applicationid = vApplicationID
                and     m.userid = p.userid
                and     (pInactiveSinceDate is null or m.LastActivityDate <= pInactiveSinceDate)
                and     (pUserNameToMatch is null or lower(m.username) like lower(pUserNameToMatch))
                and     (a.isdeleted = 0)
                -- and     (     (pProfileAuthOptions = 2)
                --            or (pProfileAuthOptions = 0 and IsAnonymous = 1)
                --            or (pProfileAuthOptions = 1 and IsAnonymous = 0)
                --         )
                order by m.username
            ) a
            where rownum <= vPageUpperBound
        )
        where
            rnum >= vPageLowerBound;
    end;


    -- Public function and procedure declarations
    procedure GetProperties (
        pResultSet  in out curtype_PROFILE,
        pApplicationName    VARCHAR2,
        pUserName           VARCHAR2
    ) as
        vApplicationID  NUMBER;
        vUserID         NUMBER;
    begin
        begin
            PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID, pApplicationName);
        exception
            when no_data_found then
                return;
        end;

        begin
            vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID, pUserName);
        exception
            when no_data_found then
                return;
        end;

        --select TOP 1 PropertyNames, PropertyValuesString, PropertyValuesBinary
        open pResultSet for
            select  p.propertyname, p.propertyvalue, p.propertytype
            from    us_Profile p
            where   p.userid = vUserID
              and   p.applicationid = vApplicationID;
          /*
          select PropertyName,
                 extractValue(XMLType(p.PropertyValue),'/property@type') PropertyType,
                 DECODE(existsNode(XMLType(p.PropertyValue),'/property/*'),0,extractValue(XMLType(p.PropertyValue),'/property'),extract(XMLType(p.PropertyValue),'/property/*').getClobVal())  PropertyValue
             from us_PROFILE p
            where   p.userid        = vUserID
              and   p.applicationid = vApplicationID;
        */
        if (sql%rowcount > 0) then
            PR_US_MEMBERSHIP.SETLASTACTIVITYDATE(vUserID);
        end if;

    end;


    -- Public function and procedure declarations
    procedure SetProperties (
        pApplicationName        VARCHAR2,
        pPropertyName           VARCHAR2,
        pPropertyValue          VARCHAR2,
        pPropertyType           VARCHAR2,
        pUserName               VARCHAR2,
        pIsUserAnonymous        NUMBER
    ) as
        vApplicationID  NUMBER;
        vUserID         NUMBER;
        vHasProfiles    NUMBER;
    begin
        -- ***********************************************************************
        -- Comentado EJM 30/04/2007
        -- No se van a crear aplicaciones en este punto
        -- ***********************************************************************
       /* begin
            APPLICATIONS.CREATEAPPLICATION(vApplicationID, pApplicationName, '');
        exception
            when others then
                rollback;
                return;
        end;*/
        -- ***********************************************************************
        -- Comentado EJM 30/04/2007
        -- Fin de comentario
        -- ***********************************************************************

        begin
            PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID, pApplicationName);
        exception
            when no_data_found then
                --rollback;
                RAISE_APPLICATION_ERROR(-20100,'ERROR: APPLICATIONS.GETAPPLICATIONID' || ' / ' || SQLERRM);
            when others then
                RAISE_APPLICATION_ERROR(-20100,'ERROR: APPLICATIONS.GETAPPLICATIONID' || ' / ' || SQLERRM);
        end;

        begin
            vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID, pUserName);
        exception
            when no_data_found then
                --rollback;
                RAISE_APPLICATION_ERROR(-20100,'ERROR: MEMBERSHIP.GETUSERID' || ' / ' || SQLERRM);
            when others then
                RAISE_APPLICATION_ERROR(-20100,'ERROR: MEMBERSHIP.GETUSERID' || ' / ' || SQLERRM);
        end;

        begin
            PR_US_MEMBERSHIP.SETLASTACTIVITYDATE(vUserID);
        exception
            when others then
                --rollback;
                RAISE_APPLICATION_ERROR(-20100,'ERROR: MEMBERSHIP.SETLASTACTIVITYDATE' || ' / ' || SQLERRM);
        end;


        begin
            vHasProfiles := 0;
            select count(p.userid)
              into vHasProfiles
              from us_PROFILE p
             where p.userid        = vUserID
               and p.applicationid = vApplicationID
               and p.propertyname  = pPropertyName;
        exception
            when no_data_found then
                vHasProfiles := 0;
            when others then
                 RAISE_APPLICATION_ERROR(-20100,'ERROR: cuenta de profiles' || ' / ' || SQLERRM);
        end;

            if (vHasProfiles > 0) then
                begin
                    update  us_PROFILE p
                    set     p.propertyvalue = pPropertyValue,
                            p.propertytype = pPropertyType
                    where   p.userid = vUserId
                      and   p.applicationid = vApplicationID
                      and   p.propertyname = pPropertyName;
                exception
                    when others then
                        --rollback;
                        RAISE_APPLICATION_ERROR(-20100,'ERROR: update! vHasProfiles:' || vHasProfiles || ' / ' || SQLERRM);
                end;
            else

                begin
                    insert into us_PROFILE p
                            (p.applicationid, p.userid, p.propertyname , p.propertytype, p.propertyvalue)
                    values  (vApplicationID , vUserID , pPropertyName , pPropertyType, pPropertyValue );
                    --RAISE_APPLICATION_ERROR(-20100,vApplicationID||','||vUserID||','||pPropertyName||','||pPropertyValue);
                exception
                    when others then
                        --rollback;
                        RAISE_APPLICATION_ERROR(-20100,'ERROR: insert! vHasProfiles:' || vHasProfiles || ' / ' || SQLERRM);
                end;
            end if;


        begin
            PR_US_PROFILE.SetLastUpdatedDate(vApplicationID, vUserID);
        exception
            when others then
                --rollback;
                RAISE_APPLICATION_ERROR(-20100,'ERROR: PROFILE.SetLastUpdatedDate' || ' / ' || SQLERRM);
        end;

        commit;

    end;


    -- Public function and procedure declarations
	   -- internal
	procedure SetLastUpdatedDate (
        pApplicationID  NUMBER,
        pUserID  NUMBER
	) as
	begin
		update us_PROFILE a
		set LASTUPDATEDDATE = sysdate
		where a.APPLICATIONID = pApplicationID
		  and a.USERID = pUserID;
	end;

    procedure GetProperty (
        pResultSet  in out curtype_PROFILE,
        pApplicationName    VARCHAR2,
        pPropertyName       VARCHAR2,
        pUserName           VARCHAR2
    ) as
        vApplicationID  NUMBER;
        vUserID         NUMBER;
    begin
        --begin
            PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID, pApplicationName);
        --exception
        --    when no_data_found then
        --        return;
        --end;

        --begin
            vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID, pUserName);
        --exception
        --    when no_data_found then
        --        return;
        --end;

        --select TOP 1 PropertyNames, PropertyValuesString, PropertyValuesBinary
        open pResultSet for
            select PropertyType, propertyname , PropertyValue
              FROM us_PROFILE p
        /*
         select PropertyName,
                 extractValue(XMLType(p.PropertyValue),'/property@type') PropertyType,
                 DECODE(existsNode(XMLType(p.PropertyValue),'/property/*'),0,extractValue(XMLType(p.PropertyValue),'/property'),extract(XMLType(p.PropertyValue),'/property/*').getClobVal())  PropertyValue

            SELECT extractValue(XMLType(value(T).getstringval()),'/child::node()') Attribute_Value --,
            FROM us_PROFILE p,
            table(
                 DECODE(existsNode(XMLType(p.propertyvalue),'/child::node()/*'),0,XMLSequence(extract(XMLType(p.propertyvalue),'/child::node()')),XMLSequence(extract(XMLType(p.propertyvalue),'/child::node()/*')))
                 ) T
     */
            where   p.userid        = vUserID
              and   p.applicationid = vApplicationID
              and   p.propertyname  = pPropertyName;

        if (sql%rowcount > 0) then
            PR_US_MEMBERSHIP.SETLASTACTIVITYDATE(vUserID);
        end if;

    end;

    function GetDecodedProperty (
        pApplicationName    VARCHAR2,
        pPropertyName       VARCHAR2,
        pUserName           VARCHAR2
    ) return TblData PIPELINED as
        pResultSet curtype_Profile;
        vApplicationID  NUMBER;
        vUserID         NUMBER;
        vValor          varchar2(4000);
        out_rec tblData;
    begin
        begin
            PR_US_APPLICATIONS.GETAPPLICATIONID(vApplicationID, pApplicationName);
        exception
            when no_data_found then
                 vApplicationID:=0;
        end;

        begin
            vUserID := PR_US_MEMBERSHIP.GETUSERID(vApplicationID, pUserName);
        exception
            when no_data_found then
                    vUserID:=0;
        end;

        --select TOP 1 PropertyNames, PropertyValuesString, PropertyValuesBinary
        open pResultSet for


            SELECT to_char(extractValue(XMLType(value(T).getstringval()),'/child::node()')) AttribValue
            FROM us_PROFILE p,
            table(
                 DECODE(existsNode(XMLType(p.propertyvalue),'/child::node()/*'),0,XMLSequence(extract(XMLType(p.propertyvalue),'/child::node()')),XMLSequence(extract(XMLType(p.propertyvalue),'/child::node()/*')))
                 ) T
            where   p.userid        = vUserID
              and   p.applicationid = vApplicationID
              and   p.propertyname  = pPropertyName;
--              and   to_char(extractValue(XMLType(value(T).getstringval()),'/child::node()')) = to_char(pValueToCompare);


            LOOP
                FETCH pResultSet INTO vValor;
                EXIT WHEN pResultSet%NOTFOUND;

                PIPE ROW(vValor);
            END LOOP;
            CLOSE pResultSet;
            return;


    end;

END;
-- END PL/SQL BLOCK (do not remove this line) ----------------------------------
/


-- End of DDL Script for Package USPROVIDER.PR_US_PROFILE

