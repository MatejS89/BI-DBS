-- odeberu pokud existuje funkce na oodebrání tabulek a sekvencí
DROP FUNCTION IF EXISTS remove_all();

-- vytvořím funkci která odebere tabulky a sekvence
CREATE or replace FUNCTION remove_all() RETURNS void AS $$
DECLARE
    rec RECORD;
    cmd text;
BEGIN
    cmd := '';

    FOR rec IN SELECT
            'DROP SEQUENCE ' || quote_ident(n.nspname) || '.'
                || quote_ident(c.relname) || ' CASCADE;' AS name
        FROM
            pg_catalog.pg_class AS c
        LEFT JOIN
            pg_catalog.pg_namespace AS n
        ON
            n.oid = c.relnamespace
        WHERE
            relkind = 'S' AND
            n.nspname NOT IN ('pg_catalog', 'pg_toast') AND
            pg_catalog.pg_table_is_visible(c.oid)
    LOOP
        cmd := cmd || rec.name;
    END LOOP;

    FOR rec IN SELECT
            'DROP TABLE ' || quote_ident(n.nspname) || '.'
                || quote_ident(c.relname) || ' CASCADE;' AS name
        FROM
            pg_catalog.pg_class AS c
        LEFT JOIN
            pg_catalog.pg_namespace AS n
        ON
            n.oid = c.relnamespace WHERE relkind = 'r' AND
            n.nspname NOT IN ('pg_catalog', 'pg_toast') AND
            pg_catalog.pg_table_is_visible(c.oid)
    LOOP
        cmd := cmd || rec.name;
    END LOOP;

    EXECUTE cmd;
    RETURN;
END;
$$ LANGUAGE plpgsql;
-- zavolám funkci co odebere tabulky a sekvence - Mohl bych dropnout celé schéma a znovu jej vytvořit, použíjeme však PLSQL
select remove_all();
-- End of removing

-- Remove conflicting tables
DROP TABLE IF EXISTS kolaj CASCADE;
DROP TABLE IF EXISTS n_vagon_jazda CASCADE;
DROP TABLE IF EXISTS naklad CASCADE;
DROP TABLE IF EXISTS nakladny_vagon CASCADE;
DROP TABLE IF EXISTS o_vagon_jazda CASCADE;
DROP TABLE IF EXISTS odosielatel CASCADE;
DROP TABLE IF EXISTS osoba CASCADE;
DROP TABLE IF EXISTS osobny_vagon CASCADE;
DROP TABLE IF EXISTS pasazier CASCADE;
DROP TABLE IF EXISTS steward CASCADE;
DROP TABLE IF EXISTS strojvodca CASCADE;
DROP TABLE IF EXISTS vlak CASCADE;
DROP TABLE IF EXISTS vlak_jazda CASCADE;
DROP TABLE IF EXISTS vypravca CASCADE;
DROP TABLE IF EXISTS vypravca_kolaj CASCADE;
-- End of removing

CREATE TABLE kolaj (
    cislo SERIAL NOT NULL
);
ALTER TABLE kolaj ADD CONSTRAINT pk_kolaj PRIMARY KEY (cislo);

CREATE TABLE n_vagon_jazda (
    id_n_vagon_jazda SERIAL NOT NULL,
    id_n_vagon INTEGER NOT NULL,
    id_vlak_jazda INTEGER NOT NULL
);
ALTER TABLE n_vagon_jazda ADD CONSTRAINT pk_n_vagon_jazda PRIMARY KEY (id_n_vagon_jazda);

CREATE TABLE naklad (
    id_naklad SERIAL NOT NULL,
    id_n_vagon_jazda INTEGER NOT NULL,
    id_odosielatel INTEGER NOT NULL,
    nazov VARCHAR(256) NOT NULL
);
ALTER TABLE naklad ADD CONSTRAINT pk_naklad PRIMARY KEY (id_naklad);
ALTER TABLE naklad ADD CONSTRAINT u_fk_naklad_n_vagon_jazda UNIQUE (id_n_vagon_jazda);

CREATE TABLE nakladny_vagon (
    id_n_vagon SERIAL NOT NULL,
    typ VARCHAR(256) NOT NULL
);
ALTER TABLE nakladny_vagon ADD CONSTRAINT pk_nakladny_vagon PRIMARY KEY (id_n_vagon);

CREATE TABLE o_vagon_jazda (
    id_o_vagon_jazda SERIAL NOT NULL,
    id_o_vagon INTEGER NOT NULL,
    id_osoba INTEGER,
    id_vlak_jazda INTEGER NOT NULL
);
ALTER TABLE o_vagon_jazda ADD CONSTRAINT pk_o_vagon_jazda PRIMARY KEY (id_o_vagon_jazda);

CREATE TABLE odosielatel (
    id_odosielatel SERIAL NOT NULL,
    meno VARCHAR(256) NOT NULL
);
ALTER TABLE odosielatel ADD CONSTRAINT pk_odosielatel PRIMARY KEY (id_odosielatel);

CREATE TABLE osoba (
    id_osoba SERIAL NOT NULL,
    meno VARCHAR(256) NOT NULL,
    priezvisko VARCHAR(256) NOT NULL
);
ALTER TABLE osoba ADD CONSTRAINT pk_osoba PRIMARY KEY (id_osoba);

CREATE TABLE osobny_vagon (
    id_o_vagon SERIAL NOT NULL,
    typ VARCHAR(256) NOT NULL
);
ALTER TABLE osobny_vagon ADD CONSTRAINT pk_osobny_vagon PRIMARY KEY (id_o_vagon);

CREATE TABLE pasazier (
    id_jazda_pasazier SERIAL NOT NULL,
    id_osoba INTEGER NOT NULL,
    id_o_vagon_jazda INTEGER NOT NULL,
    miesto INTEGER NOT NULL
);
ALTER TABLE pasazier ADD CONSTRAINT pk_pasazier PRIMARY KEY (id_jazda_pasazier);

CREATE TABLE steward (
    id_osoba INTEGER NOT NULL,
    zamestnavatel VARCHAR(256) NOT NULL
);
ALTER TABLE steward ADD CONSTRAINT pk_steward PRIMARY KEY (id_osoba);

CREATE TABLE strojvodca (
    id_osoba INTEGER NOT NULL,
    zamestnavatel VARCHAR(256) NOT NULL
);
ALTER TABLE strojvodca ADD CONSTRAINT pk_strojvodca PRIMARY KEY (id_osoba);

CREATE TABLE vlak (
    id_vlak SERIAL NOT NULL
);
ALTER TABLE vlak ADD CONSTRAINT pk_vlak PRIMARY KEY (id_vlak);

CREATE TABLE vlak_jazda (
    id_vlak_jazda SERIAL NOT NULL,
    cislo INTEGER NOT NULL,
    id_vlak INTEGER NOT NULL,
    id_osoba INTEGER NOT NULL,
    datum DATE NOT NULL,
    cas_odjazdu TIME NOT NULL,
    ciel VARCHAR(256) NOT NULL,
    vzdialenost INTEGER NOT NULL
);
ALTER TABLE vlak_jazda ADD CONSTRAINT pk_vlak_jazda PRIMARY KEY (id_vlak_jazda);

CREATE TABLE vypravca (
    id_osoba INTEGER NOT NULL,
    plat INTEGER NOT NULL
);
ALTER TABLE vypravca ADD CONSTRAINT pk_vypravca PRIMARY KEY (id_osoba);

CREATE TABLE vypravca_kolaj (
    id_osoba INTEGER NOT NULL,
    cislo INTEGER NOT NULL
);
ALTER TABLE vypravca_kolaj ADD CONSTRAINT pk_vypravca_kolaj PRIMARY KEY (id_osoba, cislo);

ALTER TABLE n_vagon_jazda ADD CONSTRAINT fk_n_vagon_jazda_nakladny_vagon FOREIGN KEY (id_n_vagon) REFERENCES nakladny_vagon (id_n_vagon) ON DELETE CASCADE;
ALTER TABLE n_vagon_jazda ADD CONSTRAINT fk_n_vagon_jazda_vlak_jazda FOREIGN KEY (id_vlak_jazda) REFERENCES vlak_jazda (id_vlak_jazda) ON DELETE CASCADE;

ALTER TABLE naklad ADD CONSTRAINT fk_naklad_n_vagon_jazda FOREIGN KEY (id_n_vagon_jazda) REFERENCES n_vagon_jazda (id_n_vagon_jazda) ON DELETE CASCADE;
ALTER TABLE naklad ADD CONSTRAINT fk_naklad_odosielatel FOREIGN KEY (id_odosielatel) REFERENCES odosielatel (id_odosielatel) ON DELETE CASCADE;

ALTER TABLE o_vagon_jazda ADD CONSTRAINT fk_o_vagon_jazda_osobny_vagon FOREIGN KEY (id_o_vagon) REFERENCES osobny_vagon (id_o_vagon) ON DELETE CASCADE;
ALTER TABLE o_vagon_jazda ADD CONSTRAINT fk_o_vagon_jazda_steward FOREIGN KEY (id_osoba) REFERENCES steward (id_osoba) ON DELETE CASCADE;
ALTER TABLE o_vagon_jazda ADD CONSTRAINT fk_o_vagon_jazda_vlak_jazda FOREIGN KEY (id_vlak_jazda) REFERENCES vlak_jazda (id_vlak_jazda) ON DELETE CASCADE;

ALTER TABLE pasazier ADD CONSTRAINT fk_pasazier_osoba FOREIGN KEY (id_osoba) REFERENCES osoba (id_osoba) ON DELETE CASCADE;
ALTER TABLE pasazier ADD CONSTRAINT fk_pasazier_o_vagon_jazda FOREIGN KEY (id_o_vagon_jazda) REFERENCES o_vagon_jazda (id_o_vagon_jazda) ON DELETE CASCADE;

ALTER TABLE steward ADD CONSTRAINT fk_steward_osoba FOREIGN KEY (id_osoba) REFERENCES osoba (id_osoba) ON DELETE CASCADE;

ALTER TABLE strojvodca ADD CONSTRAINT fk_strojvodca_osoba FOREIGN KEY (id_osoba) REFERENCES osoba (id_osoba) ON DELETE CASCADE;

ALTER TABLE vlak_jazda ADD CONSTRAINT fk_vlak_jazda_kolaj FOREIGN KEY (cislo) REFERENCES kolaj (cislo) ON DELETE CASCADE;
ALTER TABLE vlak_jazda ADD CONSTRAINT fk_vlak_jazda_vlak FOREIGN KEY (id_vlak) REFERENCES vlak (id_vlak) ON DELETE CASCADE;
ALTER TABLE vlak_jazda ADD CONSTRAINT fk_vlak_jazda_strojvodca FOREIGN KEY (id_osoba) REFERENCES strojvodca (id_osoba) ON DELETE CASCADE;

ALTER TABLE vypravca ADD CONSTRAINT fk_vypravca_osoba FOREIGN KEY (id_osoba) REFERENCES osoba (id_osoba) ON DELETE CASCADE;

ALTER TABLE vypravca_kolaj ADD CONSTRAINT fk_vypravca_kolaj_vypravca FOREIGN KEY (id_osoba) REFERENCES vypravca (id_osoba) ON DELETE CASCADE;
ALTER TABLE vypravca_kolaj ADD CONSTRAINT fk_vypravca_kolaj_kolaj FOREIGN KEY (cislo) REFERENCES kolaj (cislo) ON DELETE CASCADE;

