WITH EmailData AS (
    SELECT
        ap.id as ap_profile_id,
        ap.site_id as profile_sub_site_id,
        ap.user_id,
        ap.npi_record_id,
        ap.last_opened_email,
        al2sub.id AS subscription_id,
        al2sub.profile_id as al2sub_profile_id,
        al2sub.created as profile_created,
        al2sub.modified as profile_modified,
        al2sub.is_active,
        al2sub.term_id as profile_subcribed_term_id,
        tb.id AS tb_browse_id,
        tb.display AS browse_display,
        tb.root AS browse_root,
        abt.id AS abt_browse_id,
        abt.display AS abt_browse_display,
        abt.id_0 as site_id,
        abt.display_0 AS site_display,
        abt.id_1 as l2_id,
        abt.display_1 AS l2_display,
        abt.id_2 as l3_id,
        abt.display_2 AS l3_display,
        bbm.email_count
    FROM
        accounts_profile AS ap
    JOIN
        analytics_denormprofile AS adp ON ap.npi_record_id = adp.npi_record
    JOIN
        accounts_l2contentsubscription AS al2sub ON ap.id = al2sub.profile_id
    JOIN
        term_browse AS tb ON al2sub.term_id = tb.id
    JOIN
        analytics_browse_tree AS abt ON CAST(al2sub.term_id AS INTEGER) = CAST(abt.id AS INTEGER)
    LEFT JOIN (
        SELECT
            user_id,
            COUNT(id) AS email_count
        FROM
            bet_betmail
        WHERE
            send_date >= '2024-04-01' AND send_date <= '2024-04-30'
            AND bet_pool_id IS NOT NULL
        GROUP BY
            user_id
    ) AS bbm ON ap.user_id = bbm.user_id
    WHERE
        ap.npi_record_id IS NOT NULL
        AND ap.site_id = 2384
        AND CAST(abt.id_0 AS INTEGER) = 2384
        AND ap.email_unsubscription IS NULL
        AND adp.date_joined < '2024-04-01'
),
AggregatedEmailCounts AS (
    SELECT
        npi_record_id,
        COALESCE(AVG(email_count), 0) AS avg_emails  -- Use COALESCE to handle cases with no emails
    FROM
        EmailData
    GROUP BY
        npi_record_id
)
SELECT
    COUNT(DISTINCT CASE WHEN avg_emails <= 10 THEN npi_record_id END) AS npi_with_10_or_less_avg_emails,
    COUNT(DISTINCT CASE WHEN avg_emails > 10 THEN npi_record_id END) AS npi_with_more_than_10_avg_emails
FROM
    AggregatedEmailCounts;

