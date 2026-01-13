-- 1. Milyen pizzák közül lehet rendelni, és mennyibe kerülnek?
SELECT pizza.pnev, pizza.par
FROM `pizza`;

-- 2. Ki szállította házhoz az első (egyes sorszámú) rendelést?
SELECT futar.fnev
FROM `futar`
JOIN `rendeles` ON futar.fazon = rendeles.fazon
WHERE rendeles.razon = 1;

-- 3. Kik rendeltek pizzát délután?
SELECT DISTINCT vevo.vnev
FROM `vevo`
JOIN `rendeles` ON vevo.vazon = rendeles.vazon
WHERE HOUR(rendeles.idopont) BETWEEN 12 AND 18;

-- 4. Ki szállított házhoz Kuka-nak?
SELECT DISTINCT futar.fnev
FROM `futar`
JOIN `rendeles` ON futar.fazon = rendeles.fazon
JOIN `vevo` ON rendeles.vazon = vevo.vazon
WHERE vevo.vnev = 'Kuka';

-- 5. Hány darab Sorrento pizza fogyott összesen?
SELECT SUM(tetel.db) AS `Sorrento db`
FROM `tetel`
JOIN `pizza` ON tetel.pazon = pizza.pazon
WHERE pizza.pnev = 'Sorrento';

-- 6. A fogyasztás alapján mi a pizzák népszerűségi sorrendje?
SELECT pizza.pnev, COALESCE(SUM(tetel.db), 0) AS `Eladott db`
FROM `pizza`
LEFT JOIN `tetel` ON pizza.pazon = tetel.pazon
GROUP BY pizza.pazon
ORDER BY COALESCE(SUM(tetel.db), 0) DESC;

-- 7. Melyik nap fogyott a legtöbb pizza?
SELECT DATE(rendeles.idopont) AS `Dátum`, SUM(tetel.db) AS `Eladott db`
FROM `rendeles`
JOIN `tetel` ON rendeles.razon = tetel.razon
GROUP BY DATE(rendeles.idopont)
ORDER BY SUM(tetel.db) DESC LIMIT 1;

-- 8. Mennyit költöttek pizzára az egyes vevők?
SELECT vevo.vnev, SUM(pizza.par * tetel.db) AS `Összesen költött`
FROM `vevo`
JOIN `rendeles` ON vevo.vazon = rendeles.vazon
JOIN `tetel` ON rendeles.razon = tetel.razon
JOIN `pizza` ON tetel.pazon = pizza.pazon
GROUP BY vevo.vazon;

-- 9. Mennyit vettek az egyes vevők a különböző pizzákból?
SELECT vevo.vnev, pizza.pnev, SUM(tetel.db) AS `Vásárolt db`
FROM `pizza`
JOIN `tetel` ON pizza.pazon = tetel.pazon
JOIN `rendeles` ON tetel.razon = rendeles.razon
JOIN `vevo` ON rendeles.vazon = vevo.vazon
GROUP BY vevo.vazon, pizza.pazon;

-- 10. Mennyi volt a bevétel az egyes napokon?
SELECT DATE(rendeles.idopont) AS `Dátum`, SUM(pizza.par * tetel.db) AS `Napi bevétel`
FROM `rendeles`
JOIN `tetel` ON rendeles.razon = tetel.razon
JOIN `pizza` ON tetel.pazon = pizza.pazon
GROUP BY DATE(rendeles.idopont);

-- 11. Ki hány pizzát rendelt az egyes napokon?
SELECT vevo.vnev, DATE(rendeles.idopont) AS `Dátum`, SUM(tetel.db) AS `Rendelt db`
FROM `vevo`
JOIN `rendeles` ON vevo.vazon = rendeles.vazon
JOIN `tetel` ON rendeles.razon = tetel.razon
GROUP BY vevo.vazon, DATE(rendeles.idopont);

-- 12. Mely pizzából fogyott legalább 40 db?
SELECT pizza.pnev, SUM(tetel.db) AS `Eladott db`
FROM `pizza`
JOIN `tetel` ON pizza.pazon = tetel.pazon
GROUP BY pizza.pazon
HAVING SUM(tetel.db) >= 40;

-- 13. Töröld az "F" betűvel kezdődő pizzát a "Pizza" táblából.
DELETE FROM `pizza`
WHERE pizza.pnev LIKE 'F%';

-- 14. Frissítsd a "Imperial" futár telefonszámát "06301234"-re!
UPDATE `futar`
SET futar.ftel = '06301234'
WHERE futar.fnev = 'Imperial';

-- 15. Szúrj be egy új pizzát, "Songoku" névvel, akinek a ára 1000 HUF!
INSERT INTO `pizza` (pnev, par)
VALUES ('Songoku', 1000);

-- 16. Kik rendeltek legalább 5 Capricciosa vagy 8 Frutti di Mare pizzát?
SELECT DISTINCT vevo.vnev
FROM `vevo`
JOIN `rendeles` ON vevo.vazon = rendeles.vazon
JOIN `tetel` ON rendeles.razon = tetel.razon
JOIN `pizza` ON tetel.pazon = pizza.pazon
GROUP BY vevo.vazon
HAVING SUM(CASE WHEN pizza.pnev = 'Capricciosa' THEN tetel.db ELSE 0 END) >= 5
  OR SUM(CASE WHEN pizza.pnev = 'Frutti di Mare' THEN tetel.db ELSE 0 END) >= 8;