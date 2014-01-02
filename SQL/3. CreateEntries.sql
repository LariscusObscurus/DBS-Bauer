﻿TRUNCATE STALL CASCADE;
TRUNCATE ANGESTELLTER CASCADE;
TRUNCATE TIER CASCADE;
TRUNCATE LAGER CASCADE;
TRUNCATE FUTTER CASCADE;
TRUNCATE DUENGER CASCADE;
TRUNCATE ATTRIBUTE CASCADE;
TRUNCATE SAATGUT CASCADE;

INSERT INTO STALL VALUES (1, 'Schweinestall', '1000', 'Nebenhof');
INSERT INTO STALL VALUES (2, 'Kuhstall', '1000', 'Haupthof');
INSERT INTO STALL VALUES (3, 'Hühnerstall', '1000', 'Haupthof');

INSERT INTO ATTRIBUTE VALUES (1, 'Tierart', 'Hausschwein');
INSERT INTO ATTRIBUTE VALUES (2, 'Tierart', 'Hausrind');
INSERT INTO ATTRIBUTE VALUES (3, 'Tierart', 'Haushuhn');

INSERT INTO FUTTER VALUES (1, 'Medizinfutter', 10);
INSERT INTO FUTTER VALUES (2, 'Wachtumsfutter', 5);
INSERT INTO FUTTER VALUES (3, 'Hühnerfutter', 1);
INSERT INTO FUTTER VALUES (4, 'Heu', 0.5);

INSERT INTO DUENGER VALUES (1, 'Schweinedung', 0);
INSERT INTO DUENGER VALUES (2, 'Kuhdung', 0);
INSERT INTO DUENGER VALUES (3, 'Pestizid', 12);
INSERT INTO DUENGER VALUES (4, 'Wachstumsdünger', 5);

INSERT INTO SAATGUT VALUES (1, 'Mais', 3);
INSERT INTO SAATGUT VALUES (2, 'Genmais', 1.5);
INSERT INTO SAATGUT VALUES (3, 'Getreide', 1);
INSERT INTO SAATGUT VALUES (4, 'Karotten', 2);
INSERT INTO SAATGUT VALUES (5, 'Zuckerrübe', 3);
INSERT INTO SAATGUT VALUES (6, 'Erdäpfel', 2.5);

INSERT INTO LAGER VALUES (1, 'Silo', 100000);
INSERT INTO LAGER VALUES (2, 'Dachspeicher', 500);
INSERT INTO LAGER VALUES (3, 'Scheune', 100);
INSERT INTO LAGER VALUES (4, 'Großspeicher', 5000);
INSERT INTO LAGER VALUES (5, 'Saatsilo', 1500);

DO $$

BEGIN
-- Schweine
	FOR i IN 1..1001 LOOP
		INSERT INTO TIER VALUES(i, 1, null, now(), now(), (i + 200) % 300);
		INSERT INTO TIER_ATTRIBUTE VALUES(i, 1);
		INSERT INTO FUTTERMENGE_PRO_TIER VALUES(i, 2, 5);
	END LOOP;
-- Rinder
	FOR i IN 1002..2002 LOOP
		INSERT INTO TIER VALUES(i, 2, null, now(), now(), (i + 300) % 500);
		INSERT INTO TIER_ATTRIBUTE VALUES(i, 2);
		INSERT INTO FUTTERMENGE_PRO_TIER VALUES(i, 2, 3);
		INSERT INTO FUTTERMENGE_PRO_TIER VALUES(i, 4, 3);
		INSERT INTO TIERARZTBESUCH(fk_tier,datum, diagnose, medikamente) VALUES (i, current_date + i % 10, null, null);
	END LOOP;
-- Hühner
	FOR i IN 2003..3003 LOOP
		INSERT INTO TIER VALUES(i, 3, null, now(), now(), i % 3);
		INSERT INTO TIER_ATTRIBUTE VALUES(i, 3);
		INSERT INTO FUTTERMENGE_PRO_TIER VALUES(i, 3, 1.5);
	END LOOP;
END$$;

--SELECT * FROM TIER;
--TRUNCATE STALL CASCADE;

INSERT INTO ANGESTELLTER VALUES (1, 'Bartholomeus', 'Kufstein', '2211010203', 1500.75, null, 'maennlich');
INSERT INTO ANGESTELLTER VALUES (2, 'Lothar', 'Semmering', '3322020304', 2750.25, null, 'maennlich');
INSERT INTO ANGESTELLTER VALUES (3, 'Gertrude', 'Pommern', '4433030405', 2500.50, null, 'weiblich');
INSERT INTO ANGESTELLTER VALUES (4, 'Kunigunde', 'Holstein', '5544040506', 1750.25, null, 'weiblich');

INSERT INTO MASCHINE VALUES (1, 3, 75000.0, date '2012-01-01', date '2012-01-01' + 1825, 'Steyr Traktor', '6140 PROFI');
INSERT INTO MASCHINE VALUES (2, 3, 97500.0, date '2012-03-02', date '2012-03-02' + 1825, 'Steyr Traktor', 'multi 4115');
INSERT INTO MASCHINE VALUES (3, 3, 199500.0, date '2011-11-05', date '2011-11-05' + 1825, 'Fendt Mähdrescher', '9490 X AL');

INSERT INTO FUTTER_BESTAND VALUES (1, 4, 200);
INSERT INTO FUTTER_BESTAND VALUES (2, 4, 1000);
INSERT INTO FUTTER_BESTAND VALUES (3, 4, 500);
INSERT INTO FUTTER_BESTAND VALUES (4, 2, 450);

INSERT INTO DUENGER_BESTAND VALUES (3, 4, 1500);
INSERT INTO DUENGER_BESTAND VALUES (4, 4, 1500);

INSERT INTO SAATGUT_BESTAND VALUES (1, 5, 100);
INSERT INTO SAATGUT_BESTAND VALUES (2, 5, 200);
INSERT INTO SAATGUT_BESTAND VALUES (3, 5, 150);
INSERT INTO SAATGUT_BESTAND VALUES (4, 5, 20);
INSERT INTO SAATGUT_BESTAND VALUES (5, 5, 20);
INSERT INTO SAATGUT_BESTAND VALUES (6, 5, 150);

INSERT INTO MASCHINE_VERWENDUNG VALUES (1, 1, now(), 2);
INSERT INTO MASCHINE_VERWENDUNG VALUES (2, 2, now(), 2);
INSERT INTO MASCHINE_VERWENDUNG VALUES (3, 3, now(), 5.5);

INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (1, 4, 'Stall gereinigt', now(), 3.5);
INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (2, 4, 'Stall gereinigt', now(), 1.0);
INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (3, 4, 'Stall gereinigt', now(), 1.0);
INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (1, 1, 'Schweine gefüttert', now(), 1.5);
INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (2, 1, 'Kühe gefüttert', now(), 1);
INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (3, 1, 'Hühner gefüttert', now(), 1);
INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (1, 2, 'Anlagen gewartet', now(), 2.5);
INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (2, 2, 'Anlagen gewartet', now(), 0.5);
INSERT INTO ANGESTELLTER_STALLARBEITEN VALUES (3, 2, 'Anlagen gewartet', now(), 0.5);