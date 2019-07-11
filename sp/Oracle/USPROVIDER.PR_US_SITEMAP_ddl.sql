-- Start of DDL Script for Package USPROVIDER.PR_US_SITEMAP
-- Generated 28-Feb-2011 10:50:41 from USPROVIDER@COPIAPRE.world

CREATE OR REPLACE 
PACKAGE pr_us_sitemap
  IS

    TYPE CURSORTYPE IS REF CURSOR;
    -------------------------------------------------------------------
    -- BUILDSITEMAP(pAPPLICATIONNAME)
    -- Obtiene el site map de una aplicacion especifica
    -------------------------------------------------------------------
    PROCEDURE BUILDSITEMAP(
        pAPPLICATIONNAME  VARCHAR2,
        pUSERNAME VARCHAR2,
        sPCURSOR OUT pr_us_SITEMAP.CURSORTYPE);

FUNCTION VerificarRoleNode (pUserId NUMBER, pApplicationId NUMBER, pMapId NUMBER) RETURN NUMBER;

END; -- Package spec
-- END PL/SQL BLOCK (do not remove this line) ----------------------------------
/


CREATE OR REPLACE 
PACKAGE BODY pr_us_sitemap 
IS

    -------------------------------------------------------------------
    -- BUILDSITEMAP(pAPPLICATIONNAME)
    -- Obtiene el site map de una aplicacion especifica
    -------------------------------------------------------------------
    PROCEDURE BUILDSITEMAP(
        pAPPLICATIONNAME  VARCHAR2,
        pUSERNAME VARCHAR2,
        sPCURSOR OUT PR_US_SITEMAP.CURSORTYPE) AS

    vAPPLICATIONID NUMBER;
    vUSERID	NUMBER;
    pSTATUS NUMBER;
    --ROL SITEMAP.CURSORTYPE;
    BEGIN
        pSTATUS := 0;

        -- Buscar el identificador de la aplicacion
        BEGIN
            PR_US_APPLICATIONS.GETAPPLICATIONID(vAPPLICATIONID,pAPPLICATIONNAME);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            vAPPLICATIONID:=-1;
            RAISE_APPLICATION_ERROR(-20100,'ERROR: NO HAY APLICACIONES CON EL NOMBRE '||pAPPLICATIONNAME||' / '||SQLERRM);
            --RETURN;
        END;

        -- Buscar el identificador del usuario
        BEGIN
            vUSERID := PR_US_MEMBERSHIP.GETUSERID(vAPPLICATIONID,pUSERNAME);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            pSTATUS := -32;
            --RETURN;
        END;


        /*
        OPEN sPCURSOR FOR
            select *
            from us_sitemap a
            where a.applicationid = vAPPLICATIONID
            --and PR_US_SITEMAP.verificarrolenode(vUSERID, a.applicationid,a.mapid) > 0
            start with parentid is null connect by prior mapid=parentid;
        */

        OPEN sPCURSOR FOR
            select * from (
                select * from us_sitemap a
                where a.applicationid = vAPPLICATIONID
                --order by a.title
            )
            start with parentid is null connect by prior mapid=parentid
            order by mapid;

    END;



    FUNCTION VerificarRoleNode (pUserId NUMBER, pApplicationId NUMBER, pMapId NUMBER) RETURN NUMBER
    IS
        vHay    NUMBER := 0;
        vRoleId NUMBER;

        CURSOR C_VEH IS
        SELECT A.ROLEID
          FROM us_ROLES A,us_USERSINROLES B
         WHERE A.APPLICATIONID = pApplicationId
           AND A.ROLEID = B.ROLEID
           AND B.USERID = pUserId;

    BEGIN
        FOR REG IN C_VEH LOOP
            vRoleId:=REG.RoleId;
            select count(a.mapid) n
              INTO vHay
              from us_sitemap a
              where (instr(a.roles,vRoleId) >= 1 OR instr(a.roles,'*') >= 1)
                and a.mapid = pMapId;

            if vHay > 0 THEN
                EXIT;
            END IF;
        END LOOP;

        RETURN vHay;
    END;

END;
-- END PL/SQL BLOCK (do not remove this line) ----------------------------------
/


-- End of DDL Script for Package USPROVIDER.PR_US_SITEMAP

