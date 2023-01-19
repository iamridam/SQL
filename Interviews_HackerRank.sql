-- Samantha interviews many candidates from different colleges using coding challenges and contests. Write a query to print the contest_id, hacker_id, name, 
-- and the sums of total_submissions, total_accepted_submissions, total_views, and total_unique_views for each contest sorted by contest_id. 
-- Exclude the contest from the result if all four sums are 0.


-- Select ct.contest_id, ct.hacker_id, ct.name,
-- sum(vs.total_views),sum(vs.total_unique_views),
-- sum(ss.total_submissions), sum(ss.total_accepted_submissions)
-- from contests ct
-- join colleges cl
-- on ct.contest_id=cl.contest_id
-- join challenges ch
-- on cl.college_id=ch.college_id
-- join view_stats vs
-- on ch.challenge_id=vs.challenge_id
-- join submission_stats ss 
-- on ch.challenge_id=ss.challenge_id
-- group by ct.contest_id, ct.hacker_id, ct.name, ch.challenge_id
-- order by ct.contest_id



WITH submissions AS (
    SELECT
        co.contest_id,
        SUM(ss.total_submissions) tot_sub,
        SUM(ss.total_accepted_submissions) tot_acc_sub
    FROM 
        Colleges co
            JOIN
        Challenges ch ON co.college_id = ch.college_id 
            JOIN
        Submission_Stats ss ON ch.challenge_id = ss.challenge_id
    GROUP BY co.contest_id
), 
views AS (
    SELECT
        co.contest_id,
        SUM(vs.total_views) tot_views,
        SUM(vs.total_unique_views) tot_uni_views
    FROM 
        Colleges co
            JOIN
        Challenges ch ON co.college_id = ch.college_id 
            JOIN
        View_Stats vs ON ch.challenge_id = vs.challenge_id
    GROUP BY co.contest_id
)

SELECT 
    c.contest_id,
    c.hacker_id,
    c.name,
    s.tot_sub,
    s.tot_acc_sub,
    v.tot_views,
    v.tot_uni_views
FROM
    Contests c
        JOIN
    submissions s ON c.contest_id = s.contest_id
        JOIN
    views v ON s.contest_id = v.contest_id