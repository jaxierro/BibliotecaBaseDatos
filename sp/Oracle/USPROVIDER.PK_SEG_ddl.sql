-- Start of DDL Script for Package USPROVIDER.PK_SEG
-- Generated 28-Feb-2011 10:49:39 from USPROVIDER@COPIAPRE.world

CREATE OR REPLACE 
PACKAGE pk_seg
  IS
--
-- To modify this template, edit file PKGSPEC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the package
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------
   -- Enter package declarations as shown below

TYPE T_CURSOR IS REF	CURSOR;
    WK_EXISTE number:=0;
   PROCEDURE GETSITEMAPALL
     (I_APPLICATIONID  IN us_sitemap.applicationid%type,
      O_CURSOR       OUT T_CURSOR,
      O_RESULT       OUT NUMBER,
      O_DESCERROR    OUT VARCHAR2);

   PROCEDURE DeleteSiteMap
     (I_APPLICATIONID  IN us_sitemap.applicationid%type,
      I_MAPID          IN us_sitemap.mapid%type,
      O_RESULT       OUT NUMBER,
      O_DESCERROR    OUT VARCHAR2);

   PROCEDURE GETSITEMAP
     (I_MAPID  IN us_sitemap.mapid%type,
      O_CURSOR       OUT T_CURSOR,
      O_RESULT       OUT NUMBER,
      O_DESCERROR    OUT VARCHAR2);

    PROCEDURE GetListRoles
     (I_APPLICATIONID       IN  NUMBER,
      O_CURSOR       OUT T_CURSOR,
      O_RESULT       OUT NUMBER,
      O_DESCERROR    OUT VARCHAR2);

    PROCEDURE InsertSiteMap
    ( I_APPLICATIONID IN US_SITEMAP.applicationid%TYPE,
      I_TITLE         IN US_SITEMAP.title%TYPE,
      I_DESCRIPTION   IN US_SITEMAP.description%TYPE,
      I_URL           IN US_SITEMAP.url%TYPE,
      I_ROLES         IN US_SITEMAP.roles%TYPE,
      I_PARENTID      IN US_SITEMAP.parentid%TYPE,
      O_RESULT       OUT NUMBER,
      O_DESCERROR    OUT VARCHAR2);

    PROCEDURE GetListUsuarioall
    ( I_APPLICATIONID IN US_MEMBERSHIP_APPLICATION.applicationid%TYPE,
      O_CURSOR       OUT T_CURSOR,
      O_RESULT       OUT NUMBER,
      O_DESCERROR    OUT VARCHAR2);

    PROCEDURE UpdateSiteMap
    ( I_MAPID IN US_SITEMAP.mapid%TYPE,
      I_APPLICATIONID IN US_SITEMAP.applicationid%TYPE,
      I_TITLE         IN US_SITEMAP.title%TYPE,
      I_DESCRIPTION   IN US_SITEMAP.description%TYPE,
      I_URL           IN US_SITEMAP.url%TYPE,
      I_ROLES         IN US_SITEMAP.roles%TYPE,
      I_PARENTID      IN US_SITEMAP.parentid%TYPE,
      O_RESULT       OUT NUMBER,
      O_DESCERROR    OUT VARCHAR2);

    PROCEDURE UpdateSiteMapCons
    ( I_MAPID IN US_SITEMAP.mapid%TYPE,
      I_APPLICATIONID IN US_SITEMAP.applicationid%TYPE,
      I_TITLE         IN US_SITEMAP.title%TYPE,
      I_DESCRIPTION   IN US_SITEMAP.description%TYPE,
      I_URL           IN US_SITEMAP.url%TYPE,
      O_RESULT       OUT NUMBER,
      O_DESCERROR    OUT VARCHAR2);

END; -- Package spec
/


CREATE OR REPLACE 
PACKAGE BODY            pk_seg
IS
--
-- To modify this template, edit file PKGBODY.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the package body
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------
   -- Enter procedure, function bodies as shown below

    PROCEDURE GETSITEMAPALL
     (I_APPLICATIONID  IN us_sitemap.applicationid%type,
      O_CURSOR       OUT T_CURSOR,
      O_RESULT       OUT NUMBER,
      O_DESCERROR    OUT VARCHAR2)

    IS

   BEGIN
       OPEN O_CURSOR FOR
       select s.APPLICATIONID, s.MAPID, s.TITLE, s.DESCRIPTION,
       s.URL, s.ROLES, s.PARENTID,NVL(p.TITLE,'') as "parent",
       'MenuEdit.aspx?id=' || to_char(s.MAPID) as "url_modmenu"
       from   us_sitemap s
       left join us_sitemap p on p.MAPID = s.parentid
       where  s.APPLICATIONID=I_APPLICATIONID;
   exception
      when others then
         O_RESULT:=0;
         O_DESCERROR:=substr(sqlerrm,1,255);
         close O_CURSOR;
   END;

   PROCEDURE DeleteSiteMap
     (I_APPLICATIONID  IN us_sitemap.applicationid%type,
      I_MAPID          IN us_sitemap.mapid%type,
      O_RESULT       OUT NUMBER,
      O_DESCERROR    OUT VARCHAR2)

      IS


    BEGIN

       SELECT count(*)
       INTO   WK_EXISTE
       FROM   us_sitemap
       WHERE  applicationid = I_APPLICATIONID
       AND    MAPID         = I_MAPID;

       if WK_EXISTE <> 0 then
          DELETE
          FROM   us_sitemap
          WHERE  applicationid = I_APPLICATIONID
          AND    MAPID         = I_MAPID;
       end if;

   exception
      when others then
         O_RESULT:=0;
         O_DESCERROR:=substr(sqlerrm,1,255);
        END;

    PROCEDURE GETSITEMAP
     (I_MAPID  IN us_sitemap.mapid%type,
      O_CURSOR       OUT T_CURSOR,
      O_RESULT       OUT NUMBER,
      O_DESCERROR    OUT VARCHAR2)

    IS

   BEGIN
       OPEN O_CURSOR FOR
       select APPLICATIONID, MAPID, TITLE, DESCRIPTION, URL, ROLES, PARENTID
       from   us_sitemap
       where  MAPID=I_MAPID;
   exception
      when others then
         O_RESULT:=0;
         O_DESCERROR:=substr(sqlerrm,1,255);
         close O_CURSOR;
   END;



    PROCEDURE GetListRoles
     (I_APPLICATIONID       IN  NUMBER,
      O_CURSOR       OUT T_CURSOR,
      O_RESULT       OUT NUMBER,
      O_DESCERROR    OUT VARCHAR2)


    IS

   BEGIN
       OPEN O_CURSOR FOR
       select APPLICATIONID, ROLEID, ROLENAME, DESCRIPTION
       from   US_ROLES
       where  APPLICATIONID=I_APPLICATIONID;
   exception
      when others then
         O_RESULT:=0;
         O_DESCERROR:=substr(sqlerrm,1,255);
         close O_CURSOR;
   END;

    PROCEDURE InsertSiteMap
    ( I_APPLICATIONID IN US_SITEMAP.applicationid%TYPE,
      I_TITLE         IN US_SITEMAP.title%TYPE,
      I_DESCRIPTION   IN US_SITEMAP.description%TYPE,
      I_URL           IN US_SITEMAP.url%TYPE,
      I_ROLES         IN US_SITEMAP.roles%TYPE,
      I_PARENTID      IN US_SITEMAP.parentid%TYPE,
      O_RESULT       OUT NUMBER,
      O_DESCERROR    OUT VARCHAR2)
   IS
   BEGIN
           INSERT INTO US_SITEMAP
           (APPLICATIONID, MAPID, TITLE, DESCRIPTION, URL, ROLES, PARENTID)
           VALUES
           (I_APPLICATIONID, SQ_US_SITEMAP.NEXTVAL, I_TITLE, I_DESCRIPTION, I_URL, I_ROLES, I_PARENTID);
           O_RESULT:=1;
           O_DESCERROR:='Proceso realizado satisfactoriamente';
   END;


    PROCEDURE GetListUsuarioall
    ( I_APPLICATIONID IN US_MEMBERSHIP_APPLICATION.applicationid%TYPE,
      O_CURSOR       OUT T_CURSOR,
      O_RESULT       OUT NUMBER,
      O_DESCERROR    OUT VARCHAR2)
    is
    begin
       OPEN O_CURSOR FOR
       select u.userid, uu.firstname
       from   US_MEMBERSHIP_APPLICATION u,
              US_MEMBERSHIP uu
       where  u.applicationid = 1
       and    u.userid = uu.userid
       order by 2;
       O_RESULT:=1;
       O_DESCERROR:='Proceso realizado satisfactoriamente';

   exception
      when others then
         O_RESULT:=0;
         O_DESCERROR:=substr(sqlerrm,1,255);
         close O_CURSOR;
   END;

    PROCEDURE UpdateSiteMap
    ( I_MAPID IN US_SITEMAP.mapid%TYPE,
      I_APPLICATIONID IN US_SITEMAP.applicationid%TYPE,
      I_TITLE         IN US_SITEMAP.title%TYPE,
      I_DESCRIPTION   IN US_SITEMAP.description%TYPE,
      I_URL           IN US_SITEMAP.url%TYPE,
      I_ROLES         IN US_SITEMAP.roles%TYPE,
      I_PARENTID      IN US_SITEMAP.parentid%TYPE,
      O_RESULT       OUT NUMBER,
      O_DESCERROR    OUT VARCHAR2)
   IS
   BEGIN
           UPDATE US_SITEMAP
           set   TITLE = I_TITLE,
           DESCRIPTION = I_DESCRIPTION,
           URL = I_URL,
           ROLES = I_ROLES,
           PARENTID = I_PARENTID
           where mapid = I_MAPID and
           APPLICATIONID = I_APPLICATIONID;

           O_RESULT:=1;
           O_DESCERROR:='Proceso realizado satisfactoriamente';
   END;

    PROCEDURE UpdateSiteMapCons
    ( I_MAPID IN US_SITEMAP.mapid%TYPE,
      I_APPLICATIONID IN US_SITEMAP.applicationid%TYPE,
      I_TITLE         IN US_SITEMAP.title%TYPE,
      I_DESCRIPTION   IN US_SITEMAP.description%TYPE,
      I_URL           IN US_SITEMAP.url%TYPE,
      O_RESULT       OUT NUMBER,
      O_DESCERROR    OUT VARCHAR2)
   IS
   BEGIN
           UPDATE US_SITEMAP
           set   TITLE = I_TITLE,
           DESCRIPTION = I_DESCRIPTION,
           URL = I_URL
           where mapid = I_MAPID and
           APPLICATIONID = I_APPLICATIONID;

           O_RESULT:=1;
           O_DESCERROR:='Proceso realizado satisfactoriamente';
   END;


END;
/


-- End of DDL Script for Package USPROVIDER.PK_SEG

