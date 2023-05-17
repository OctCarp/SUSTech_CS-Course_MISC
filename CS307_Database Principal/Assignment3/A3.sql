--P1
CREATE OR REPLACE FUNCTION add_post_revision() RETURNS TRIGGER AS
$$
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        INSERT INTO PostRevision VALUES (DEFAULT, OLD.PostID, now(), OLD.Content, NEW.Content);
        RETURN NEW;
    END IF;
END
$$
    LANGUAGE plpgsql;

CREATE TRIGGER post_content_update
    AFTER UPDATE
    ON Post
    FOR EACH ROW
EXECUTE FUNCTION add_post_revision();

CREATE OR REPLACE FUNCTION delete_post() RETURNS TRIGGER AS
$$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO DeleteLog VALUES (DEFAULT, OLD.PostID, now());
        DELETE FROM PostRevision WHERE PostID = OLD.PostID;
        RETURN NEW;
    END IF;
END
$$
    LANGUAGE plpgsql;

CREATE TRIGGER post_delete
    AFTER DELETE
    ON Post
    FOR EACH ROW
EXECUTE FUNCTION delete_post();


--P2
CREATE OR REPLACE FUNCTION tin_check()
    RETURNS TRIGGER
AS
$$
DECLARE
    arr      int[]  := array [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2];
    sum      integer=0;
    checksum integer;
BEGIN
    NEW.nation := 'cn';
    NEW.type := 'person';

    IF NEW.tin SIMILAR TO '[0-9]{17}([0-9]|X)' THEN
        NEW.format := 'cn id';
        
        FOR i IN 1..17
            LOOP
                sum := sum + arr[i] * (substring(NEW.tin FROM i FOR 1) ::integer);
            END LOOP;

        IF substring(NEW.tin FROM 18 FOR 1) = 'X' THEN
            checksum = 10;
        ELSE
            checksum = substring(NEW.tin FROM 18 FOR 1) :: integer;
        END IF;

        IF (12 - sum % 11) % 11 != checksum THEN
            RAISE EXCEPTION 'ID not legal';
        END IF;

    ELSE
        IF NEW.tin SIMILAR TO 'C[0-9]{17}' THEN
            NEW.format = 'cn passport';
        ELSIF NEW.tin SIMILAR TO 'W[0-9]{17}' THEN
            NEW.format = 'fg passport';
        ELSIF NEW.tin SIMILAR TO 'H[0-9]{17}' THEN
            NEW.format = 'hk';
        ELSIF NEW.tin SIMILAR TO 'M[0-9]{17}' THEN
            NEW.format = 'mo';
        ELSIF NEW.tin SIMILAR TO 'T[0-9]{17}' THEN
            NEW.format = 'tw';
        ELSE
            RAISE EXCEPTION 'format not legal';
        END IF;
    
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER tin_trigger
    BEFORE INSERT
    ON tax_identification_number
    FOR EACH ROW
EXECUTE PROCEDURE tin_check();
