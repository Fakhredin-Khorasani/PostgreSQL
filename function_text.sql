CREATE FUNCTION func_text(func_name varchar)
  RETURNS TABLE (function varchar, full_text varchar) AS
$func$
BEGIN
   RETURN QUERY
    SELECT P.proname :: varchar, F.full_text :: varchar
    FROM
    (
      SELECT oid, proname
      FROM pg_proc
      WHERE lower(proname) like '%' || lower(func_name) || '%'
    ) AS P
    JOIN LATERAL
    (SELECT pg_get_functiondef(P.oid) AS full_text) AS F ON TRUE;
END
$func$ LANGUAGE plpgsql;
