WITH months AS (
    SELECT generate_series(
        DATE_TRUNC('month', MIN(start)),
        DATE_TRUNC('month', CURRENT_DATE),
        '1 month'
    )::date AS month_start
    FROM customer_programs_placement
    WHERE site_id = '2384'
    AND placement_type IN (20, 30)
),
active_placements AS (
    SELECT
        customer_programs_placement.id AS placement_id,
        customer_programs_placement.title AS placement_title,
        customer_programs_placement.start AS placement_start,
        month_start,
        placement_type,
        CASE
            WHEN placement_type = 20 THEN 'Lecture Series'
            WHEN placement_type = 30 THEN 'Next Best Video'
            ELSE 'Other'
        END AS placement_name
    FROM months
    JOIN customer_programs_placement ON
        months.month_start >= DATE_TRUNC('month', start) AND
        months.month_start <= DATE_TRUNC('month', "end") AND
        CURRENT_DATE BETWEEN start AND "end"
    WHERE site_id = '2384'
        AND placement_type IN (20, 30)
),
videos_per_placement AS (
    SELECT
        ap.placement_id,
        ap.placement_title,
        ap.placement_start,
        ap.placement_type,
        ap.placement_name,
        v.id AS video_id,
        v.title AS video_title,
        v.acquisition_source,
        DATE(v.created AT TIME ZONE 'UTC' AT TIME ZONE 'America/Los_Angeles') AS video_created_date,
        bm.object_id,
        MIN(bb.send_date)::date AS min_send_date,
        MAX(bb.send_date)::date AS max_send_date
    FROM active_placements ap
    JOIN customer_programs_asset a ON ap.placement_id = a.placement_id
    LEFT JOIN video_video v ON a.video_id = v.id
    LEFT JOIN bet_betmailitem bm ON v.id = bm.object_id
    LEFT JOIN bet_betmail bb ON bm.bet_mail_id = bb.id  -- Joining the bet_betmail table
    GROUP BY ap.placement_id, ap.placement_title, ap.placement_start, ap.placement_type, ap.placement_name, v.id, v.title, v.acquisition_source, v.created, bm.object_id
)

SELECT
    placement_title,
    placement_start,
    placement_type,
    placement_name,
    video_title,
    acquisition_source,
    video_created_date,
    object_id,
    min_send_date,
    max_send_date
FROM videos_per_placement
ORDER BY placement_title, video_created_date;
WITH months AS (
    SELECT generate_series(
        DATE_TRUNC('month', MIN(start)),
        DATE_TRUNC('month', CURRENT_DATE),
        '1 month'
    )::date AS month_start
    FROM customer_programs_placement
    WHERE site_id = '2384'
    AND placement_type IN (20, 30)
),
active_placements AS (
    SELECT
        customer_programs_placement.id AS placement_id,
        customer_programs_placement.title AS placement_title,
        customer_programs_placement.start AS placement_start,
        month_start,
        placement_type,
        CASE
            WHEN placement_type = 20 THEN 'Lecture Series'
            WHEN placement_type = 30 THEN 'Next Best Video'
            ELSE 'Other'
        END AS placement_name
    FROM months
    JOIN customer_programs_placement ON
        months.month_start >= DATE_TRUNC('month', start) AND
        months.month_start <= DATE_TRUNC('month', "end") AND
        CURRENT_DATE BETWEEN start AND "end"
    WHERE site_id = '2384'
        AND placement_type IN (20, 30)
),
videos_per_placement AS (
    SELECT
        ap.placement_id,
        ap.placement_title,
        ap.placement_start,
        ap.placement_type,
        ap.placement_name,
        v.id AS video_id,
        v.title AS video_title,
        v.acquisition_source,
        DATE(v.created AT TIME ZONE 'UTC' AT TIME ZONE 'America/Los_Angeles') AS video_created_date,
        bm.object_id,
        MIN(bb.send_date)::date AS min_send_date,
        MAX(bb.send_date)::date AS max_send_date
    FROM active_placements ap
    JOIN customer_programs_asset a ON ap.placement_id = a.placement_id
    LEFT JOIN video_video v ON a.video_id = v.id
    LEFT JOIN bet_betmailitem bm ON v.id = bm.object_id
    LEFT JOIN bet_betmail bb ON bm.bet_mail_id = bb.id  -- Joining the bet_betmail table
    GROUP BY ap.placement_id, ap.placement_title, ap.placement_start, ap.placement_type, ap.placement_name, v.id, v.title, v.acquisition_source, v.created, bm.object_id
)

SELECT
    placement_title,
    placement_start,
    placement_type,
    placement_name,
    video_title,
    acquisition_source,
    video_created_date,
    object_id,
    min_send_date,
    max_send_date
FROM videos_per_placement
ORDER BY placement_title, video_created_date;
