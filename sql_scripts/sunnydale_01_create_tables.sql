
BEGIN;


CREATE TABLE IF NOT EXISTS sunnydale.episodes
(
    episodeid integer NOT NULL,
    no_overall integer,
    title character varying(255) COLLATE pg_catalog."default",
    season integer,
    episode_number integer,
    air_date date,
    director character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT episodes_pkey PRIMARY KEY (episodeid)
);

CREATE TABLE IF NOT EXISTS sunnydale.ratings
(
    ratingsid integer NOT NULL,
    viewers numeric,
    imdb_rating numeric,
    imdb_votes numeric,
    episodeid integer,
    CONSTRAINT ratings_pkey PRIMARY KEY (ratingsid)
);

CREATE TABLE IF NOT EXISTS sunnydale.writers
(
    writerid integer NOT NULL,
    writer_name character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT writers_pkey PRIMARY KEY (writerid)
);

CREATE TABLE IF NOT EXISTS sunnydale.writers_episodes
(
    episodeid integer,
    writerid integer
);

ALTER TABLE IF EXISTS sunnydale.ratings
    ADD CONSTRAINT ratings_episodeid_fkey FOREIGN KEY (episodeid)
    REFERENCES sunnydale.episodes (episodeid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS sunnydale.writers_episodes
    ADD CONSTRAINT writers_episodes_episodeid_fkey FOREIGN KEY (episodeid)
    REFERENCES sunnydale.episodes (episodeid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS sunnydale.writers_episodes
    ADD CONSTRAINT writers_episodes_writerid_fkey FOREIGN KEY (writerid)
    REFERENCES sunnydale.writers (writerid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

END;