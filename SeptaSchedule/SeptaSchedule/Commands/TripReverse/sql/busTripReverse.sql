
SELECT
  NewStart.arrival_time,
  NewEnd.arrival_time,
  NewStart.block_id
FROM

  (
    SELECT
      S.stop_id,
      T.trip_id,
      ST.arrival_time,
      T.block_id
    FROM stops_bus S
      JOIN stop_times_bus ST
      ON S.stop_id = ST.stop_id
      JOIN trips_bus T
      ON ST.trip_id = T.trip_id
    WHERE S.stop_id = :start_stop_id AND T.direction_id = 1 AND T.service_id = :service_id) NewStart
  JOIN
  (SELECT
    S.stop_id,
    T.trip_id,
    ST.arrival_time
  FROM stops_bus S
    JOIN stop_times_bus ST
    ON S.stop_id = ST.stop_id
    JOIN trips_bus T
    ON ST.trip_id = T.trip_id
  WHERE S.stop_id = :end_stop_id AND T.direction_id = 1 AND T.service_id = :service_id) NewEnd
  ON NewStart.trip_id = NewEnd.trip_id;
