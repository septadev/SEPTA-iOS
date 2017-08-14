
SELECT
  S.stop_id stopId,
  S.stop_name stopName,
  cast (S.stop_lat as decimal) stopLatitude,
  cast (S.stop_lon as decimal) stopLongitude,
  case when S.wheelchair_boarding = '1' then 1 else 0  end wheelchairBoarding,
  MAX(CASE WHEN T.service_id = '1'
    THEN 1 else 0 END) weekdayService,
  MAX(CASE WHEN
    T.service_id = '2'
    THEN 1  else 0 END) saturdayService,
  MAX(CASE WHEN
    T.service_id = '3'
    THEN 1  else 0 END) AS sundayService
FROM trips_bus T
JOIN routes_bus R
ON T.route_id = R.route_id
JOIN stops_bus S
ON R.route_id = T.route_id
WHERE T.route_id = ':route_id' AND direction_id = ':direction_id'
GROUP BY S.stop_id, S.stop_name, S.stop_lat, S.stop_lon;

