1. Shema koristene baze podataka
	CREATE TABLE document (
		documentId serial PRIMARY KEY,
		title varchar(255) NOT NULL,
		keywords varchar(255) NOT NULL,
		summary text NOT NULL,
		body text NOT NULL,
		allTSV tsvector
	);

	CREATE TABLE query_history (
		queryId serial PRIMARY KEY,
		query text NOT NULL,
		queryTimestamp timestamp NOT NULL
	);

	CREATE TRIGGER document_Ins_Trigg
	BEFORE INSERT ON document
	FOR EACH ROW
	EXECUTE PROCEDURE tsvector_update_trigger(allTSV, 'pg_catalog.english', title, keywords, summary, body);

	CREATE INDEX docTSVInd ON document USING gist(allTSV);
	CREATE INDEX title_trigram_idx ON document USING gist(title gist_trgm_ops);
	CREATE INDEX keywords_trigram_idx ON document USING gist(keywords gist_trgm_ops);
	CREATE INDEX summary_trigram_idx ON document USING gist(summary gist_trgm_ops);
	CREATE INDEX body_trigram_idx ON document USING gist(body gist_trgm_ops);

	UPDATE document
		SET allTSV = setweight(to_tsvector('english', title), 'A') ||
			setweight(to_tsvector('english',keywords), 'B') ||
			setweight(to_tsvector('english',summary), 'C') ||
			setweight(to_tsvector('english',body), 'D');


2. Kratki opis koristenih tehnologija
		Ruby on Rails:
			Ruby on Rails je framework za pisanje web aplikacija koje se pokreću na serveru. Podržava web standarde poput 			JSON-a, HTML-a, CSS-a, JavaScripta itd. za prikazivanje interaktivnog sadržaja korisnicima, također podržava MVC 			obrazac.

		JavaScript:
			Skriptni jezik koji se izvršava u web pregledniku i omogućava interaktivnos web stranice.

		Ajax:
			Ajax omogućava asinkrono osvježavanje dijelova web stranica, čime povećava interaktivnost i smanjuje potrebu za 			čestim osvježavanjem stranice kada je potrebno dohvatiti podatke koji čine samo dio stranice.


3. Naputak za pokretanje rjesenja
	1. Pozicionirati se u terminalu u datoteku NMiBP_P1
	2. Izvršiti naredbu 'rails server'
	3. U internet pregledniku u polje za unos adrese unijeti 'localhost:3000'

	*Za izvođenje je potreban rails server i gem 'pg'
