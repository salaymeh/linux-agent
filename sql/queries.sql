SELECT cpu_number,id as host_id,total_mem FROM host_info
GROUP BY 1, 2, 3
ORDER BY 1,3 DESC;

SELECT hu.host_id, hi.hostname,
       round5(hu.timestamp) as round5,
       avg(avg_mem_perecentage(hi.total_mem,hu.memory_free) )as mem
FROM host_info  hi
         FULL JOIN host_usage hu on hi.id = hu.host_id
WHERE hi.id = hu.host_id
GROUP BY 1,2,3
ORDER BY 1;


SELECT hu.host_id,round5(hu.timestamp) as ts, COUNT(*) as num_data_points
FROM host_usage as hu
GROUP BY 1,2
HAVING COUNT(*) < 3
order by 3 ;



