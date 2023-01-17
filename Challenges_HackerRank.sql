-- Julia asked her students to create some coding challenges. 
-- Write a query to print the hacker_id, name, and the total number of challenges created by each student. 
-- Sort your results by the total number of challenges in descending order. 
-- If more than one student created the same number of challenges, then sort the result by hacker_id. 
-- If more than one student created the same number of challenges and the count is less than the maximum number of challenges created, then exclude those students from the result.


with cte as 
(
   Select
      h.hacker_id,
      h.name,
      count(c.challenge_id) as nos_of_challenge 		-- rank() over(order by nos_of_challenge)
   from
      hackers h 
      join
         challenges c 
         on h.hacker_id = c.hacker_id 
   group by
      h.hacker_id,
      h.name 		-- order by nos_of_challenge desc
)
,
cte2 as
(
   select
      hacker_id,
      name,
      nos_of_challenge,
      rank() over(
   order by
      nos_of_challenge desc) as challenge_rank 
   from
      cte 
)
Select
   hacker_id,
   name,
   nos_of_challenge 
from
   cte2 
where
   challenge_rank in 
   (
      Select
         challenge_rank 
      from
         cte2 
      group by
         challenge_rank 
      HAVING
         COUNT(challenge_rank) = 1 
   )
   or challenge_rank = 1 
order by
   nos_of_challenge desc,
   hacker_id asc;
