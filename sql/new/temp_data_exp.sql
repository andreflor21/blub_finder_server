 -- Seleciona os dados da tabela temp_data
CREATE TEMPORARY TABLE
  temp_data_expanded (
    year INT,
    make VARCHAR(255),
    model VARCHAR(255),
    bulb_code VARCHAR(255),
    position VARCHAR(255)
  );

-- Insere os dados expandidos na tabela temporária
INSERT INTO
  temp_data_expanded (year, make, model, bulb_code, position)
SELECT
  *
FROM
  (
    SELECT
      year,
      make,
      model,
      TRIM(
        SUBSTRING_INDEX(
          SUBSTRING_INDEX(front_fog_light, ';', numbers.n),
          ';',
          -1
        )
      ) AS bulb_code,
      'front_fog_light' AS position
    FROM
      temp_data
      JOIN (
        SELECT
          1 n
        UNION ALL
        SELECT
          2
        UNION ALL
        SELECT
          3
        UNION ALL
        SELECT
          4
        UNION ALL
        SELECT
          5
        UNION ALL
        SELECT
          6
        UNION ALL
        SELECT
          7
        UNION ALL
        SELECT
          8
        UNION ALL
        SELECT
          9
        UNION ALL
        SELECT
          10
      ) numbers ON CHAR_LENGTH(front_fog_light) - CHAR_LENGTH(
        REPLACE
          (front_fog_light, ';', '')
      ) >= numbers.n - 1
  ) t
where
  bulb_code <> ''
group by
  year,
  make,
  model,
  bulb_code,
  position
INSERT INTO
  temp_data_expanded (year, make, model, bulb_code, position)
SELECT
  *
FROM
  (
    SELECT
      year,
      make,
      model,
      TRIM(
        SUBSTRING_INDEX(
          SUBSTRING_INDEX(high_low_beam, ';', numbers.n),
          ';',
          -1
        )
      ) AS bulb_code,
      'high_low_beam' AS position
    FROM
      temp_data
      JOIN (
        SELECT
          1 n
        UNION ALL
        SELECT
          2
        UNION ALL
        SELECT
          3
        UNION ALL
        SELECT
          4
        UNION ALL
        SELECT
          5
        UNION ALL
        SELECT
          6
        UNION ALL
        SELECT
          7
        UNION ALL
        SELECT
          8
        UNION ALL
        SELECT
          9
        UNION ALL
        SELECT
          10
      ) numbers ON CHAR_LENGTH(high_low_beam) - CHAR_LENGTH(
        REPLACE
          (high_low_beam, ';', '')
      ) >= numbers.n - 1
    WHERE
      TRIM(
        SUBSTRING_INDEX(
          SUBSTRING_INDEX(high_low_beam, ';', numbers.n),
          ';',
          -1
        )
      ) <> ''
  ) t
where
  bulb_code <> ''
group by
  year,
  make,
  model,
  bulb_code,
  position;

INSERT INTO
  temp_data_expanded (year, make, model, bulb_code, position)
SELECT
  *
FROM
  (
    SELECT
      year,
      make,
      model,
      TRIM(
        SUBSTRING_INDEX(
          SUBSTRING_INDEX(low_beam, ';', numbers.n),
          ';',
          -1
        )
      ) AS bulb_code,
      'low_beam' AS position
    FROM
      temp_data
      JOIN (
        SELECT
          1 n
        UNION ALL
        SELECT
          2
        UNION ALL
        SELECT
          3
        UNION ALL
        SELECT
          4
        UNION ALL
        SELECT
          5
        UNION ALL
        SELECT
          6
        UNION ALL
        SELECT
          7
        UNION ALL
        SELECT
          8
        UNION ALL
        SELECT
          9
        UNION ALL
        SELECT
          10
      ) numbers ON CHAR_LENGTH(low_beam) - CHAR_LENGTH(
        REPLACE
          (low_beam, ';', '')
      ) >= numbers.n - 1
    WHERE
      TRIM(
        SUBSTRING_INDEX(
          SUBSTRING_INDEX(low_beam, ';', numbers.n),
          ';',
          -1
        )
      ) <> ''
  ) t
where
  bulb_code <> ''
group by
  year,
  make,
  model,
  bulb_code,
  position;

INSERT INTO
  temp_data_expanded (year, make, model, bulb_code, position)
SELECT
  *
FROM
  (
    SELECT
      year,
      make,
      model,
      TRIM(
        SUBSTRING_INDEX(
          SUBSTRING_INDEX(high_beam, ';', numbers.n),
          ';',
          -1
        )
      ) AS bulb_code,
      'high_beam' AS position
    FROM
      temp_data
      JOIN (
        SELECT
          1 n
        UNION ALL
        SELECT
          2
        UNION ALL
        SELECT
          3
        UNION ALL
        SELECT
          4
        UNION ALL
        SELECT
          5
        UNION ALL
        SELECT
          6
        UNION ALL
        SELECT
          7
        UNION ALL
        SELECT
          8
        UNION ALL
        SELECT
          9
        UNION ALL
        SELECT
          10
      ) numbers ON CHAR_LENGTH(high_beam) - CHAR_LENGTH(
        REPLACE
          (high_beam, ';', '')
      ) >= numbers.n - 1
    WHERE
      TRIM(
        SUBSTRING_INDEX(
          SUBSTRING_INDEX(high_beam, ';', numbers.n),
          ';',
          -1
        )
      ) <> ''
  ) t
where
  bulb_code <> ''
group by
  year,
  make,
  model,
  bulb_code,
  position;

-- Insere os registros na tabela bulbs_model
INSERT INTO
  bulbs_models (model_id, bulb_id)
SELECT
  mo.id as model_id,
  b.id AS bulb_id
FROM
  temp_data_expanded t
  JOIN makes m ON t.make = m.name
  JOIN models mo on mo.year = t.year
  and mo.name = t.model
  and mo.make_id = m.id
  JOIN bulbs b ON t.bulb_code = b.descr
  and b.part_id = case
    when t.position = 'front_fog_light' then 1
    when t.position = 'high_low_beam' then 2
    when t.position = 'low_beam' then 3
    else 4
  end;

-- Limpa a tabela temporária
DROP TEMPORARY TABLE IF EXISTS
  temp_data_expanded;