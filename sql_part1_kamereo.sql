--Task 1: --

WITH CategorySales AS (
    SELECT 
        Channel, 
        Category, 
        SUM(GMV) AS Total_GMV
    FROM `ngocdakamereo.part1_sql.table1`
    WHERE GMV >= 1 
      AND (Category != 'Non-veggie' 
           OR (Category = 'Non-veggie' AND GMV <= 70))
    GROUP BY Channel, Category
),
RankedCategory AS (
    SELECT
        Channel,
        Category,
        Total_GMV,
        RANK() OVER (
            PARTITION BY Channel 
            ORDER BY Total_GMV DESC
        ) AS rank_desc,
        RANK() OVER (
            PARTITION BY Channel 
            ORDER BY Total_GMV ASC
        ) AS rank_asc
    FROM CategorySales
)
SELECT
    Channel,
    Category,
    Total_GMV,
    CASE
        WHEN rank_desc = 1 THEN 'Best-selling'
        WHEN rank_asc = 1 THEN 'Least-selling'
    END AS Category_Type
FROM RankedCategory
WHERE rank_desc = 1
   OR rank_asc = 1
ORDER BY Channel, Category_Type;

--Task 2: --
-- * Compare between Horeca and MT --
SELECT
    Category,
    SUM(CASE WHEN Channel = 'Horeca' THEN GMV ELSE 0 END) AS Horeca_GMV,
    SUM(CASE WHEN Channel = 'MT' THEN GMV ELSE 0 END) AS MT_GMV
FROM `ngocdakamereo.part1_sql.table1`
WHERE Channel IN ('Horeca', 'MT')
GROUP BY Category
ORDER BY Category;

-- * Compare between KA and SME --
SELECT
    Category,
    SUM(CASE WHEN Channel = 'KA' THEN GMV ELSE 0 END) AS KA_GMV,
    SUM(CASE WHEN Channel = 'SME' THEN GMV ELSE 0 END) AS SME_GMV
FROM `ngocdakamereo.part1_sql.table1`
WHERE Channel IN ('KA', 'SME')
GROUP BY Category
ORDER BY Category;

