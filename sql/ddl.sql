CREATE DATABASE host_agent;
\c host_agent;

CREATE TABLE IF NOT EXISTS host_info (
  id SERIAL NOT NULL,
  hostname VARCHAR NOT NULL,
  cpu_number INT NOT NULL ,
  cpu_architecture VARCHAR NOT NULL ,
  cpu_model     varchar NOT NULL ,
  cpu_mhz DECIMAL NOT NULL ,
  L2_cache INT NOT NULL ,
  total_mem INT NOT NULL ,
  "timestamp" TIMESTAMP NOT NULL,
  PRIMARY KEY(id)
);
CREATE TABLE IF NOT EXISTS host_usage (
  "timestamp" TIMESTAMP NOT NULL,
  host_id SERIAL NOT NULL,
  memory_free INT NOT NULL ,
  cpu_idle INT NOT NULL ,
  cpu_kernel INT NOT NULL ,
  disk_io INT NOT NULL ,
  disk_available INT NOT NULL ,
  PRIMARY KEY ("timestamp",host_id),
  FOREIGN KEY(host_id) REFERENCES host_info(id)
);

CREATE FUNCTION round5(ts timestamp) RETURNS timestamp AS
$$
BEGIN
    RETURN date_trunc('hour', ts) + date_part('minute', ts):: int / 5 * interval '5 min';
END;
$$
    LANGUAGE PLPGSQL;

CREATE FUNCTION avg_mem_perecentage(total_mem int, memory_free int) RETURNS INT
    AS
    $$
       BEGIN
            return (round(((total_mem / 1000) - memory_free),2)/(total_mem/1000)) * 100;

       END;
    $$
    LANGUAGE PLPGSQL;

