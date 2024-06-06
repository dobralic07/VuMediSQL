SELECT
    m.user_id,
    s.name,
    m.confidence,
    p.confidence_score,
    tb.display
FROM
    listmatch_source s
JOIN
    listmatch_candidate c ON s.id = c.source_id
JOIN
    listmatch_match m ON c.id = m.candidate_id
JOIN
    recommendation_browseinterestprediction p ON m.user_id = p.user_id
JOIN
    term_browse tb ON p.browse_id = tb.id
WHERE
     s.name = 'Fabhalta PNH 2/2024'
    AND m.confidence = 1
    AND (tb.display LIKE 'Hematology' OR p.confidence_score IN (1, 2));
