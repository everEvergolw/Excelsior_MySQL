DROP DATABASE IF EXISTS Excelsior;

CREATE DATABASE Excelsior;

USE Excelsior;



-- TABLE publishers
CREATE TABLE publishers (
  publisher_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL

);


-- TABLE series
CREATE TABLE series (
  series_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL ,
  inception_year INT NOT NULL ,
  publisher_id INT NOT NULL ,
  CONSTRAINT pk_serie_publisher FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id)
);

-- TABLE comics
CREATE TABLE comics (
  comic_id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL ,
  issue_number INT NOT NULL ,
  release_date DATE NOT NULL ,
  series_id INT NOT NULL ,
  type ENUM('Comic', 'Graphic Novel'),
  edition VARCHAR(20) NOT NULL ,
  signed_by_creator BOOLEAN NOT NULL,
  cover_date DATE NOT NULL,
  CONSTRAINT pk_comic_series
  FOREIGN KEY (series_id) REFERENCES series(series_id)
);




-- TABLE quality_mapping
CREATE TABLE quality_mapping (
  quality_mapping_id INT PRIMARY KEY AUTO_INCREMENT,
  comic_id INT NOT NULL,
  comics_condition VARCHAR(10) NOT NULL,
  condition_number DECIMAL(4,2) NOT NULL,
  CONSTRAINT pk_quality_comic
      FOREIGN KEY (comic_id) REFERENCES comics(comic_id)
);

-- TABLE creators
CREATE TABLE creators (
  creator_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  role VARCHAR(50) NOT NULL ,
  biography TEXT NOT NULL
);


-- TABLE characters

CREATE TABLE characters (
  character_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL

);



-- TABLE comic_characters

CREATE TABLE comic_characters (
  comic_character_id INT PRIMARY KEY AUTO_INCREMENT,
  comic_id INT NOT NULL,
  character_id INT NOT NULL,
  CONSTRAINT pk_comic_comic FOREIGN KEY (comic_id) REFERENCES comics(comic_id),
  CONSTRAINT pk_character_character FOREIGN KEY (character_id) REFERENCES characters(character_id),

  UNIQUE (comic_id, character_id)
);


-- TABLE comic_creators

CREATE TABLE comic_creators (
  comic_creator_id INT PRIMARY KEY AUTO_INCREMENT,
  comic_id INT NOT NULL,
  creator_id INT NOT NULL,
  CONSTRAINT pk_comic_comic_c FOREIGN KEY (comic_id) REFERENCES comics(comic_id),
  CONSTRAINT pk_comic_comic_ct FOREIGN KEY (creator_id) REFERENCES creators(creator_id),

  UNIQUE (comic_id, creator_id)
);

-- TABLE prices

CREATE TABLE prices (
  price_id INT PRIMARY KEY AUTO_INCREMENT,
  comic_id INT NOT NULL,
  purchase_price FLOAT NOT NULL ,
  sale_price FLOAT NOT NULL ,
  quality VARCHAR(10) NOT NULL ,
  last_updated DATE NOT NULL ,
  CONSTRAINT pk_price_comic FOREIGN KEY (comic_id) REFERENCES comics(comic_id)
);

-- TABLE overstreet_price_guide
CREATE TABLE overstreet_price_guide (
  overstreet_price_guide_id INT PRIMARY KEY AUTO_INCREMENT,
  comic_id INT NOT NULL,
  year INT NOT NULL,
  Fair_price FLOAT NOT NULL,
  Good_price FLOAT NOT NULL,
  Very_good_price FLOAT NOT NULL,
  Fine_price FLOAT NOT NULL,
  Very_fine_price FLOAT NOT NULL,
  Near_mint_price FLOAT NOT NULL,
  Mint_price FLOAT NOT NULL,
  CONSTRAINT overstreet_price_guide FOREIGN KEY (comic_id) REFERENCES comics(comic_id)

);

















-- PL/SQL

-- PROCEDURES

-- FUNCTION

-- GetSeriesIdByName When insert a comic with its series
CREATE FUNCTION GetSeriesIdByName(seriesName VARCHAR(100))
RETURNS INT
BEGIN
  DECLARE seriesId INT;
  SELECT series_id INTO seriesId FROM series WHERE name = seriesName;
  RETURN seriesId;
END;


-- Insert Part PROCEDURES

-- Insert  publishers  Reduces duplication.
DELIMITER //

CREATE PROCEDURE insert_publisher_if_not_exists(
    IN publisher_name VARCHAR(255)
)
BEGIN
    IF NOT EXISTS (
        SELECT * FROM publishers WHERE name = publisher_name
    ) THEN
        INSERT INTO publishers (name) VALUES (publisher_name);
    END IF;
END //

DELIMITER ;





-- Insert  series Reduces duplication.

DELIMITER //

CREATE PROCEDURE insert_series_if_not_exists(
    IN series_name VARCHAR(255),
    IN inception_year INT,
    IN publisher_name VARCHAR(255)
)
BEGIN
    DECLARE publisher_ids INT;
    SELECT publisher_id  INTO publisher_ids FROM publishers WHERE name = publisher_name;

    IF NOT EXISTS (
        SELECT * FROM series WHERE name = series_name AND inception_year = inception_year AND publisher_id = publisher_id
    ) THEN
        INSERT INTO series (name, inception_year, publisher_id) VALUES (series_name, inception_year, publisher_ids);
    END IF;
END //


DELIMITER ;



-- Insert characters Reduces duplication.

DELIMITER //

CREATE PROCEDURE insert_character_if_not_exists(
    IN character_name VARCHAR(255)
)
BEGIN
    IF NOT EXISTS (
        SELECT * FROM characters WHERE name = character_name
    ) THEN
        INSERT INTO characters (name) VALUES (character_name);
    END IF;
END //

DELIMITER ;


DELIMITER //




-- Insert creators Reduces duplication.
CREATE PROCEDURE insert_if_not_exists_creators (
    IN creator_name VARCHAR(255),
    IN creator_role VARCHAR(255),
    IN creator_bio TEXT
)
BEGIN
    IF NOT EXISTS (
        SELECT *
        FROM creators
        WHERE name = creator_name
        AND role = creator_role
    ) THEN
        INSERT INTO creators (name, role, biography)
        VALUES (creator_name, creator_role, creator_bio);
    END IF;
END;
//

DELIMITER ;


 -- insert_comic_character_if_not_exists Reduces duplication.
DELIMITER //

CREATE PROCEDURE insert_comic_character_if_not_exists(
IN comic_id INT,
IN character_name VARCHAR(255))

BEGIN

    DECLARE character_ids INT;

    SELECT character_id INTO character_ids FROM characters WHERE name = character_name;

    INSERT INTO comic_characters (comic_id, character_id) VALUES (comic_id, character_ids);

END;
//
DELIMITER ;



 -- insert_comic_character_if_not_exists Reduces duplication.
DELIMITER //

CREATE PROCEDURE insert_comic_creator_if_not_exists(
IN comic_id INT,
IN creator_name VARCHAR(255))
BEGIN

    DECLARE creator_ids INT;

    SELECT creator_id INTO creator_ids FROM creators WHERE name = creator_name;

    INSERT INTO comic_creators (comic_id, creator_id) VALUES (comic_id, creator_ids);

END;
//

DELIMITER ;






















/* Insert Data into Tables */

-- Insert  publishers

-- Call the stored procedure for each publisher in the list
CALL insert_publisher_if_not_exists('Marvel Comics');
CALL insert_publisher_if_not_exists('DC Comics');
CALL insert_publisher_if_not_exists('Image Comics');
CALL insert_publisher_if_not_exists('Dark Horse Comics');
CALL insert_publisher_if_not_exists('DC Comics');
CALL insert_publisher_if_not_exists('Marvel Comics');
CALL insert_publisher_if_not_exists('IDW Publishing');
CALL insert_publisher_if_not_exists('DC Comics');
CALL insert_publisher_if_not_exists('Dark Horse Comics');
CALL insert_publisher_if_not_exists('Marvel Comics');
CALL insert_publisher_if_not_exists('IDW Publishing');
CALL insert_publisher_if_not_exists('DC Comics');
CALL insert_publisher_if_not_exists('Marvel Comics');
CALL insert_publisher_if_not_exists('Dark Horse Comics');
CALL insert_publisher_if_not_exists('Vertigo');
CALL insert_publisher_if_not_exists('IDW Publishing');
CALL insert_publisher_if_not_exists('Boom! Studios');
CALL insert_publisher_if_not_exists('Dark Horse Comics');
CALL insert_publisher_if_not_exists('Valiant Comics');
CALL insert_publisher_if_not_exists('IDW Publishing');
CALL insert_publisher_if_not_exists('Dark Horse Comics');
CALL insert_publisher_if_not_exists('Valiant Comics');
CALL insert_publisher_if_not_exists('Boom! Studios');
CALL insert_publisher_if_not_exists('Archie Comics');
CALL insert_publisher_if_not_exists('IDW Publishing');
CALL insert_publisher_if_not_exists('Dark Horse Comics');
CALL insert_publisher_if_not_exists('BOOM! Studios');
CALL insert_publisher_if_not_exists('DC Comics');
CALL insert_publisher_if_not_exists('Marvel Comics');
CALL insert_publisher_if_not_exists('Dark Horse Comics');
CALL insert_publisher_if_not_exists('Vertigo');
CALL insert_publisher_if_not_exists('DC Comics');
CALL insert_publisher_if_not_exists('Marvel Comics');
CALL insert_publisher_if_not_exists('Dark Horse Comics');
CALL insert_publisher_if_not_exists('IDW Publishing');
CALL insert_publisher_if_not_exists('Marvel Comics');
CALL insert_publisher_if_not_exists('Marvel Comics');
CALL insert_publisher_if_not_exists('Marvel Comics');
CALL insert_publisher_if_not_exists('Marvel Comics');




-- Insert  series
CALL insert_series_if_not_exists('The Incredible Hulk', 1962, 'Marvel Comics');
CALL insert_series_if_not_exists('Batman', 1939, 'DC Comics');
CALL insert_series_if_not_exists('Spawn', 1992, 'Image Comics');
CALL insert_series_if_not_exists('Hellboy', 1993, 'Dark Horse Comics');
CALL insert_series_if_not_exists('Batman', 1940, 'DC Comics');
CALL insert_series_if_not_exists('Spider-Man', 1963, 'Marvel Comics');
CALL insert_series_if_not_exists('Teenage Mutant Ninja Turtles', 1984, 'IDW Publishing');
CALL insert_series_if_not_exists('Watchmen', 1986, 'DC Comics');
CALL insert_series_if_not_exists('Hellboy', 1993, 'Dark Horse Comics');
CALL insert_series_if_not_exists('Daredevil', 1964, 'Marvel Comics');
CALL insert_series_if_not_exists('Locke & Key', 2008, 'IDW Publishing');
CALL insert_series_if_not_exists('Watchmen', 1986, 'DC Comics');
CALL insert_series_if_not_exists('X-Men', 1963, 'Marvel Comics');
CALL insert_series_if_not_exists('Hellboy', 1994, 'Dark Horse Comics');
CALL insert_series_if_not_exists('Preacher', 1995, 'Vertigo');
CALL insert_series_if_not_exists('Locke & Key', 2008, 'IDW Publishing');
CALL insert_series_if_not_exists('Lumberjanes', 2014, 'Boom! Studios');
CALL insert_series_if_not_exists('Hellboy', 1994, 'Dark Horse Comics');
CALL insert_series_if_not_exists('X-O Manowar', 1992, 'Valiant Comics');
CALL insert_series_if_not_exists('Teenage Mutant Ninja Turtles', 2011, 'IDW Publishing');
CALL insert_series_if_not_exists('Hellboy', 1993, 'Dark Horse Comics');
CALL insert_series_if_not_exists('X-O Manowar', 1992, 'Valiant Comics');
CALL insert_series_if_not_exists('Lumberjanes', 2014, 'Boom! Studios');
CALL insert_series_if_not_exists('Sabrina the Teenage Witch', 2019, 'Archie Comics');
CALL insert_series_if_not_exists('Locke & Key', 2008, 'IDW Publishing');
CALL insert_series_if_not_exists('Hellboy', 1994, 'Dark Horse Comics');
CALL insert_series_if_not_exists('Lumberjanes', 2014, 'BOOM! Studios');
CALL insert_series_if_not_exists('Batman', 1940, 'DC Comics');
CALL insert_series_if_not_exists('X-Men', 1963, 'Marvel Comics');
CALL insert_series_if_not_exists('Sin City', 1991, 'Dark Horse Comics');
CALL insert_series_if_not_exists('Sandman', 1989, 'Vertigo');
CALL insert_series_if_not_exists('Watchmen', 1986, 'DC Comics');
CALL insert_series_if_not_exists('Spider-Man', 1963, 'Marvel Comics');
CALL insert_series_if_not_exists('Hellboy', 1994, 'Dark Horse Comics');
CALL insert_series_if_not_exists('Locke & Key', 2008, 'IDW Publishing');
CALL insert_series_if_not_exists('The Incredible Hulk', 1962, 'Marvel Comics');
CALL insert_series_if_not_exists('The Incredible Hulk', 1962, 'Marvel Comics');
CALL insert_series_if_not_exists('The Incredible Hulk', 1962, 'Marvel Comics');
CALL insert_series_if_not_exists('Spider-Man', 1974, 'Marvel Comics');



-- Insert creators

CALL insert_if_not_exists_creators('Stan Lee', 'Writer', 'Stan Lee was a legendary comic book writer, editor, and publisher.');
CALL insert_if_not_exists_creators('Bob Kanes', 'Writer', 'Bob Kane was an American comic book writer and artist.');
CALL insert_if_not_exists_creators('Todd McFarlane', 'Writer/Artist', 'Todd McFarlane is a Canadian comic book creator and entrepreneur, best known for his work on The Amazing Spider-Man and the horror-fantasy series Spawn.');
CALL insert_if_not_exists_creators('Mike Mignola', 'Writer/Artist', 'Mike Mignola is an American comic book artist and writer, best known for creating the dark fantasy series Hellboy.');
CALL insert_if_not_exists_creators('Denny ONeil', 'Writer', 'Denny ONeil was an American comic book writer and editor, best known for hiswork on Batman, Green Lantern, and Green Arrow.');
CALL insert_if_not_exists_creators('Neal Adams', 'Artist', 'Neal Adams is an American comic book artist, best known for his work on Batman, X-Men, and Green Lantern/Green Arrow.');
CALL insert_if_not_exists_creators('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer, best known for co-creating many Marvel Comics characters including Spider-Man, the X-Men, and the Avengers.');
CALL insert_if_not_exists_creators('John Romita Sr.', 'Artist', 'John Romita Sr. is an American comic book artist, best known for his work on Marvel Comics characters including Spider-Man, Daredevil, and the X-Men.');
CALL insert_if_not_exists_creators('Kevin Eastman', 'Writer/Artist', 'Kevin Eastman is an American comic book writer, artist, and publisher, best known for co-creating the Teenage Mutant Ninja Turtles.');
CALL insert_if_not_exists_creators('Peter Laird', 'Writer/Artist', 'Peter Laird is an American comic book writer, artist, and publisher, best known for co-creating the Teenage Mutant Ninja Turtles.');
CALL insert_if_not_exists_creators('Alan Moore', 'Writer', 'Alan Moore is an English writer known for his work in comic books, including Watchmen, V for Vendetta, and From Hell.');
CALL insert_if_not_exists_creators('Dave Gibbons', 'Artist', 'Dave Gibbons is an English comic book artist, best known for his work on Watchmen and Green Lantern.');
CALL insert_if_not_exists_creators('Mike Mignola', 'Writer/Artist', 'Mike Mignola is an American comic book artist and writer, best known for creating the character Hellboy.');
CALL insert_if_not_exists_creators('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer, best known as the co-creator of many Marvel Comics superheroes, including Spider-Man, the X-Men, Iron Man, Thor, and the Fantastic Four.');
CALL insert_if_not_exists_creators('Bill Everett', 'Artist', 'Bill Everett was an American comic book writer and artist, best known for co-creating Marvel Comics Daredevil and Namor the Sub-Mariner.');
CALL insert_if_not_exists_creators('Jack Kirby', 'Artist', 'Jack Kirby was an American comic book artist, writer, and editor, widely regarded as one of the mediums major innovators and one of its most prolific and influential creators.');
CALL insert_if_not_exists_creators('Joe Hill', 'Writer', 'Joe Hill is an American writer, best known for his novels Heart-Shaped Box, Horns, and The Fireman.');
CALL insert_if_not_exists_creators('Gabriel Rodriguez', 'Artist', 'Gabriel Rodriguez is a Chilean comic book artist, best known for his work on Locke & Key.');
CALL insert_if_not_exists_creators('Alan Moore', 'Writer', 'Alan Moore is an English writer, best known for his work on comic books, including Watchmen, V for Vendetta, and From Hell.');
CALL insert_if_not_exists_creators('Dave Gibbons', 'Artist', 'Dave Gibbons is an English comic book artist, best known for his collaborations with writer Alan Moore, including Watchmen, for which he won the Hugo Award.');
CALL insert_if_not_exists_creators('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer, best known for co-creating many of Marvel Comics most popular characters, including Spider-Man, the X-Men, and the Fantastic Four.');
CALL insert_if_not_exists_creators('Jack Kirby', 'Artist', 'Jack Kirby was an American comic book artist, writer, and editor, widely regarded as one of the mediums major innovators and one of its most prolific and influential creators.');
CALL insert_if_not_exists_creators('Mike Mignola', 'Writer/Artist', 'Mike Mignola is an American comic book artist and writer, best known for creating the comic book series Hellboy and its various spin-offs.');
CALL insert_if_not_exists_creators('Garth Ennis', 'Writer', 'Garth Ennis is a Northern Irish-born naturalized American comics writer, best known for his work on the Vertigo series Preacher, the Marvel Comics series The Punisher, and the DC Comics series Hitman.');
CALL insert_if_not_exists_creators('Steve Dillon', 'Artist', 'Steve Dillon was a British comic book artist, best known for his work with writer Garth Ennis on Hellblazer, Preacher, and The Punisher.');
CALL insert_if_not_exists_creators('Joe Hill', 'Writer', 'Joe Hill is an American author and comic book writer, best known for his novels Heart-Shaped Box, Horns, NOS4A2, and The Fireman, and the comic book series Locke & Key.');
CALL insert_if_not_exists_creators('Gabriel Rodriguez', 'Artist', 'Gabriel Rodriguez is a Chilean comic book artist, best known for his work on the IDW Publishing series Locke & Key.');
CALL insert_if_not_exists_creators('Noelle Stevenson', 'Writer', 'Noelle Stevenson is an American cartoonist and writer, best known for her work on the webcomic Nimona and the comic book series Lumberjanes.');
CALL insert_if_not_exists_creators('Grace Ellis', 'Writer', 'Grace Ellis is an American comic book writer, best known for co-creating the comic book series Lumberjanes.');
CALL insert_if_not_exists_creators('Brooke A. Allen', 'Artist', 'Brooke A. Allen is an American comic book artist, best known for her work on the Boom! Studios series Lumberjanes.');
CALL insert_if_not_exists_creators('Mike Mignola', 'Writer/Artist', 'Mike Mignola is an American comic book artist and writer, best known for creating the Dark Horse Comics character Hellboy and contributing to various Marvel Comics series.');
CALL insert_if_not_exists_creators('Bob Layton', 'Writer', 'Bob Layton is an American comic book artist, writer, and editor, best known for his work on Marvel Comics titles such as Iron Man and Hercules.');
CALL insert_if_not_exists_creators('Jim Shooter', 'Writer', 'Jim Shooter is an American writer, editor, and publisher, best known for his work on Marvel Comics titles such as The Avengers and Secret Wars, and for serving as editor-in-chief of Marvel from 1978 to 1987.');
CALL insert_if_not_exists_creators('Barry Windsor-Smith', 'Artist', 'Barry Windsor-Smith is a British comic book artist and writer, best known for his work on Marvel Comics titles such as Conan the Barbarian and The Avengers.');
CALL insert_if_not_exists_creators('Kevin Eastman', 'Writer/Artist', 'Kevin Eastman is an American comic book artist and writer, best known as the co-creator of the Teenage Mutant Ninja Turtles.');
CALL insert_if_not_exists_creators('Tom Waltz', 'Writer', 'Tom Waltz is an American comic book writer, best known for his work on the IDW Publishing series Teenage Mutant Ninja Turtles.');
CALL insert_if_not_exists_creators('Mike Mignola', 'Writer/Artist', 'Mike Mignola is an American comic book artist and writer, best known as the creator of the character Hellboy.');
CALL insert_if_not_exists_creators('Bob Layton', 'Writer', 'Bob Layton is an American comic book writer and artist, best known for his work on Iron Man and X-O Manowar.');
CALL insert_if_not_exists_creators('Barry Windsor-Smith', 'Artist', 'Barry Windsor-Smith is a British comic book artist and writer, best known for his work on Conan the Barbarian and X-O Manowar.');
CALL insert_if_not_exists_creators('Noelle Stevenson', 'Writer', 'Noelle Stevenson is an American cartoonist and writer, best known for her work on the webcomic Nimona and the comic series Lumberjanes.');
CALL insert_if_not_exists_creators('Shannon Watters', 'Editor', 'Shannon Watters is an American editor and writer, best known for her work on the comic series Lumberjanes.');
CALL insert_if_not_exists_creators('Kelly Thompson', 'Writer', 'Kelly Thompson is an American comic book writer, best known for her work on Hawkeye, Captain Marvel, and the comic series Sabrina the Teenage Witch.');
CALL insert_if_not_exists_creators('Veronica Fish', 'Artist', 'Veronica Fish is an American comic book artist, best known for her work on the comic series Sabrina the Teenage Witch.');
CALL insert_if_not_exists_creators('Joe Hill', 'Writer', 'Joe Hill is an American writer, best known for his novels Heart-Shaped Box, Horns, and NOS4A2, as well as the comic series Locke & Key.');
CALL insert_if_not_exists_creators('Gabriel Rodriguez', 'Artist', 'Gabriel Rodriguez is a Chilean comic book artist, best known for his work on the comic series Locke & Key.');
CALL insert_if_not_exists_creators('Mike Mignola', 'Writer/Artist', 'Mike Mignola is an American comic book artist and writer, best known for creating the comic series Hellboy.');
CALL insert_if_not_exists_creators('Noelle Stevenson', 'Writer', 'Noelle Stevenson is an American comic book writer and animator, best known for creating the comic series Lumberjanes and the animated series She-Ra and the Princesses of Power.');
CALL insert_if_not_exists_creators('Brooke Allen', 'Artist', 'Brooke Allen is an American comic book artist, best known for her work on the comic series Lumberjanes.');
CALL insert_if_not_exists_creators('Denny ONeil', 'Writer', 'Denny ONeil was an American comic book writer and editor, best known for his work on Batman, Green Arrow, and other DC Comics characters.');
CALL insert_if_not_exists_creators('Neal Adams', 'Artist', 'Neal Adams is an American comic book artist, best known for his work on Batman, Green Lantern/Green Arrow, and other DC Comics characters.');
CALL insert_if_not_exists_creators('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer, best known for co-creating many of Marvel Comics most iconic characters, including Spider-Man, the X-Men, and the Avengers.');
CALL insert_if_not_exists_creators('Jack Kirby', 'Artist', 'Jack Kirby was an American comic book artist, writer, and editor, best known for co-creating many of Marvel Comics most iconic characters, including the X-Men, the Fantastic Four, and the Avengers.');
CALL insert_if_not_exists_creators('Frank Miller', 'Writer/Artist', 'Frank Miller is an American comic book writer, artist, and filmmaker, best known for his work on Sin City, Batman: The Dark Knight Returns, and Daredevil.');
CALL insert_if_not_exists_creators('Neil Gaiman', 'Writer', 'Neil Gaiman is an English author and screenwriter, best known for his work on the Sandman comic book series and the novels American Gods and Coraline.');
CALL insert_if_not_exists_creators('Alan Moore', 'Writer', 'Alan Moore is an English writer known for his work on Watchmen, V for Vendetta, and Batman: The Killing Joke.');
CALL insert_if_not_exists_creators('Dave Gibbons', 'Artist', 'Dave Gibbons is an English comic book artist known for his work on Watchmen, Batman vs. Predator, and Green Lantern.');
CALL insert_if_not_exists_creators('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer, best known for co-creating Spider-Man, the X-Men, and the Avengers.');
CALL insert_if_not_exists_creators('Steve Ditko', 'Artist', 'Steve Ditko was an American comic book artist and writer, best known for co-creating Spider-Man and Doctor Strange.');
CALL insert_if_not_exists_creators('Mike Mignola', 'Writer/Artist', 'Mike Mignola is an American comic book artist and writer, best known for creating the Hellboy comic book series.');
CALL insert_if_not_exists_creators('Joe Hill', 'Writer', 'Joe Hill is an American author and comic book writer, best known for his work on Locke & Key and the novel Heart-Shaped Box.');
CALL insert_if_not_exists_creators('Gabriel Rodriguez', 'Artist', 'Gabriel Rodriguez is a Chilean comic book artist, best known for his work on Locke & Key and Little Nemo: Return to Slumberland.');
CALL insert_if_not_exists_creators('Stan Lee', 'Writer', 'Stan Lee was a legendary comic book writer, editor, and publisher.');
CALL insert_if_not_exists_creators('Stan Lee', 'Writer', 'Stan Lee was a legendary comic book writer, editor, and publisher.');
CALL insert_if_not_exists_creators('Stan Lee', 'Writer', 'Stan Lee was a legendary comic book writer, editor, and publisher.');
CALL insert_if_not_exists_creators('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer, best known for co-creating many Marvel Comics characters including Spider-Man, the X-Men, and the Avengers.');
CALL insert_if_not_exists_creators('John Romita Sr.', 'Artist', 'John Romita Sr. is an American comic book artist, best known for his work on Marvel Comics characters including Spider-Man, Daredevil, and the X-Men.');




-- Insert characters
CALL insert_character_if_not_exists('Hulk');
CALL insert_character_if_not_exists('Batman');
CALL insert_character_if_not_exists('Spawn');
CALL insert_character_if_not_exists('Hellboy');
CALL insert_character_if_not_exists('Ras al Ghul');
CALL insert_character_if_not_exists('Kingpin');
CALL insert_character_if_not_exists('Leonardo');
CALL insert_character_if_not_exists('Raphael');
CALL insert_character_if_not_exists('Michelangelo');
CALL insert_character_if_not_exists('Donatello');
CALL insert_character_if_not_exists('Dr. Manhattan');
CALL insert_character_if_not_exists('Hellboy');
CALL insert_character_if_not_exists('Daredevil');
CALL insert_character_if_not_exists('Foggy Nelson');
CALL insert_character_if_not_exists('Karen Page');
CALL insert_character_if_not_exists('Bode Locke');
CALL insert_character_if_not_exists('Tyler Locke');
CALL insert_character_if_not_exists('Kinsey Locke');
CALL insert_character_if_not_exists('Rorschach');
CALL insert_character_if_not_exists('Dr. Manhattan');
CALL insert_character_if_not_exists('Nite Owl');
CALL insert_character_if_not_exists('Cyclops');
CALL insert_character_if_not_exists('Jean Grey');
CALL insert_character_if_not_exists('Beast');
CALL insert_character_if_not_exists('Hellboy');
CALL insert_character_if_not_exists('Jesse Custer');
CALL insert_character_if_not_exists('Tulip OHare');
CALL insert_character_if_not_exists('Cassidy');
CALL insert_character_if_not_exists('Tyler Locke');
CALL insert_character_if_not_exists('Kinsey Locke');
CALL insert_character_if_not_exists('Bode Locke');
CALL insert_character_if_not_exists('Jo');
CALL insert_character_if_not_exists('April');
CALL insert_character_if_not_exists('Mal');
CALL insert_character_if_not_exists('Hellboy');
CALL insert_character_if_not_exists('X-O Manowar');
CALL insert_character_if_not_exists('Aric of Dacia');
CALL insert_character_if_not_exists('Leonardo');
CALL insert_character_if_not_exists('Michelangelo');
CALL insert_character_if_not_exists('Donatello');
CALL insert_character_if_not_exists('Raphael');
CALL insert_character_if_not_exists('Hellboy');
CALL insert_character_if_not_exists('X-O Manowar');
CALL insert_character_if_not_exists('Jo');
CALL insert_character_if_not_exists('April');
CALL insert_character_if_not_exists('Ripley');
CALL insert_character_if_not_exists('Molly');
CALL insert_character_if_not_exists('Sabrina Spellman');
CALL insert_character_if_not_exists('Bode Locke');
CALL insert_character_if_not_exists('Tyler Locke');
CALL insert_character_if_not_exists('Kinsey Locke');
CALL insert_character_if_not_exists('Hellboy');
CALL insert_character_if_not_exists('Jo');
CALL insert_character_if_not_exists('April');
CALL insert_character_if_not_exists('Mal');
CALL insert_character_if_not_exists('Batman');
CALL insert_character_if_not_exists('Professor X');
CALL insert_character_if_not_exists('Cyclops');
CALL insert_character_if_not_exists('Jean Grey');
CALL insert_character_if_not_exists('Marv');
CALL insert_character_if_not_exists('Dream');
CALL insert_character_if_not_exists('Rorschach');
CALL insert_character_if_not_exists('Peter Parker');
CALL insert_character_if_not_exists('Hellboy');
CALL insert_character_if_not_exists('Tyler Locke');
CALL insert_character_if_not_exists('Hulk');
CALL insert_character_if_not_exists('Hulk');
CALL insert_character_if_not_exists('Hulk');
CALL insert_character_if_not_exists('The Punisher');



-- Insert character_comics

call insert_comic_character_if_not_exists( 1,'Hulk');
call insert_comic_character_if_not_exists( 2,'Batman');
call insert_comic_character_if_not_exists( 3,'Spawn');
call insert_comic_character_if_not_exists( 4,'Hellboy');
call insert_comic_character_if_not_exists( 5,'Ras al Ghul');
call insert_comic_character_if_not_exists( 6,'Kingpin');
call insert_comic_character_if_not_exists( 7,'Leonardo');
call insert_comic_character_if_not_exists(7 ,'Raphael');
call insert_comic_character_if_not_exists(7,'Michelangelo');
call insert_comic_character_if_not_exists(7,'Donatello');
call insert_comic_character_if_not_exists(8,'Dr. Manhattan');
call insert_comic_character_if_not_exists(9,'Hellboy');
call insert_comic_character_if_not_exists( 10,'Daredevil');
call insert_comic_character_if_not_exists( 10,'Foggy Nelson');
call insert_comic_character_if_not_exists( 10,'Karen Page');
call insert_comic_character_if_not_exists( 11,'Bode Locke');
call insert_comic_character_if_not_exists( 11,'Tyler Locke');
call insert_comic_character_if_not_exists( 11,'Kinsey Locke');
call insert_comic_character_if_not_exists( 12,'Rorschach');
call insert_comic_character_if_not_exists( 12,'Dr. Manhattan');
call insert_comic_character_if_not_exists( 12,'Nite Owl');
call insert_comic_character_if_not_exists( 13,'Cyclops');
call insert_comic_character_if_not_exists( 13,'Jean Grey');
call insert_comic_character_if_not_exists( 13,'Beast');
call insert_comic_character_if_not_exists( 14,'Hellboy');
call insert_comic_character_if_not_exists( 15,'Jesse Custer');
call insert_comic_character_if_not_exists( 15,'Tulip OHare');
call insert_comic_character_if_not_exists( 15,'Cassidy');
call insert_comic_character_if_not_exists( 16,'Tyler Locke');
call insert_comic_character_if_not_exists( 16,'Kinsey Locke');
call insert_comic_character_if_not_exists( 16,'Bode Locke');
call insert_comic_character_if_not_exists( 17,'Jo');
call insert_comic_character_if_not_exists( 17,'April');
call insert_comic_character_if_not_exists( 17,'Mal');
call insert_comic_character_if_not_exists( 18,'Hellboy');
call insert_comic_character_if_not_exists( 19,'X-O Manowar');
call insert_comic_character_if_not_exists( 19,'Aric of Dacia');
call insert_comic_character_if_not_exists(20,'Leonardo');
call insert_comic_character_if_not_exists( 20,'Michelangelo');
call insert_comic_character_if_not_exists( 20,'Donatello');
call insert_comic_character_if_not_exists( 20,'Raphael');
call insert_comic_character_if_not_exists( 21,'Hellboy');
call insert_comic_character_if_not_exists( 22,'X-O Manowar');
call insert_comic_character_if_not_exists( 23,'Jo');
call insert_comic_character_if_not_exists( 23,'April');
call insert_comic_character_if_not_exists( 23,'Ripley');
call insert_comic_character_if_not_exists( 23,'Molly');
call insert_comic_character_if_not_exists(24,'Sabrina Spellman');
call insert_comic_character_if_not_exists( 25,'Bode Locke');
call insert_comic_character_if_not_exists( 25,'Tyler Locke');
call insert_comic_character_if_not_exists( 25,'Kinsey Locke');
call insert_comic_character_if_not_exists( 26,'Hellboy');
call insert_comic_character_if_not_exists( 27,'Jo');
call insert_comic_character_if_not_exists( 27,'April');
call insert_comic_character_if_not_exists( 27,'Mal');
call insert_comic_character_if_not_exists( 28,'Batman');
call insert_comic_character_if_not_exists( 29,'Professor X');
call insert_comic_character_if_not_exists( 29,'Cyclops');
call insert_comic_character_if_not_exists( 29,'Jean Grey');
call insert_comic_character_if_not_exists( 30,'Marv');
call insert_comic_character_if_not_exists( 31,'Dream');
call insert_comic_character_if_not_exists( 32,'Rorschach');
call insert_comic_character_if_not_exists( 33,'Peter Parker');
call insert_comic_character_if_not_exists( 34,'Hellboy');
call insert_comic_character_if_not_exists( 35,'Tyler Locke');
call insert_comic_character_if_not_exists( 36,'Hulk');
call insert_comic_character_if_not_exists( 37,'Hulk');
call insert_comic_character_if_not_exists( 38,'Hulk');
call insert_comic_character_if_not_exists(39,'The Punisher');




-- Insert comic_creators

call insert_comic_creator_if_not_exists(1 ,'Stan Lee');
call insert_comic_creator_if_not_exists(2 ,'Bob Kanes');
call insert_comic_creator_if_not_exists(3 ,'Todd McFarlane');
call insert_comic_creator_if_not_exists(4 ,'Mike Mignola');
call insert_comic_creator_if_not_exists(5 ,'Denny ONeil');
call insert_comic_creator_if_not_exists(5 ,'Neal Adams');
call insert_comic_creator_if_not_exists(6 ,'Stan Lee');
call insert_comic_creator_if_not_exists(6 ,'John Romita Sr.');
call insert_comic_creator_if_not_exists(7 ,'Kevin Eastman');
call insert_comic_creator_if_not_exists(7 ,'Peter Laird');
call insert_comic_creator_if_not_exists(8 ,'Alan Moore');
call insert_comic_creator_if_not_exists(8 ,'Dave Gibbons');
call insert_comic_creator_if_not_exists(9 ,'Mike Mignola');
call insert_comic_creator_if_not_exists(10,'Stan Lee');
call insert_comic_creator_if_not_exists(10,'Bill Everett');
call insert_comic_creator_if_not_exists(10,'Jack Kirby');
call insert_comic_creator_if_not_exists(11,'Joe Hill');
call insert_comic_creator_if_not_exists(11,'Gabriel Rodriguez');
call insert_comic_creator_if_not_exists(12,'Alan Moore');
call insert_comic_creator_if_not_exists(12,'Dave Gibbons');
call insert_comic_creator_if_not_exists(13,'Stan Lee');
call insert_comic_creator_if_not_exists(13,'Jack Kirby');
call insert_comic_creator_if_not_exists(14,'Mike Mignola');
call insert_comic_creator_if_not_exists(15,'Garth Ennis');
call insert_comic_creator_if_not_exists(15,'Steve Dillon');
call insert_comic_creator_if_not_exists(16,'Joe Hill');
call insert_comic_creator_if_not_exists(16,'Gabriel Rodriguez');
call insert_comic_creator_if_not_exists(17,'Noelle Stevenson');
call insert_comic_creator_if_not_exists(17,'Grace Ellis');
call insert_comic_creator_if_not_exists(17,'Brooke A. Allen');
call insert_comic_creator_if_not_exists(18,'Mike Mignola');
call insert_comic_creator_if_not_exists(19,'Bob Layton');
call insert_comic_creator_if_not_exists(19,'Jim Shooter');
call insert_comic_creator_if_not_exists(19,'Barry Windsor-Smith');
call insert_comic_creator_if_not_exists(20,'Kevin Eastman');
call insert_comic_creator_if_not_exists(20,'Tom Waltz');
call insert_comic_creator_if_not_exists(21,'Mike Mignola');
call insert_comic_creator_if_not_exists(22,'Bob Layton');
call insert_comic_creator_if_not_exists(22,'Barry Windsor-Smith');
call insert_comic_creator_if_not_exists(23,'Noelle Stevenson');
call insert_comic_creator_if_not_exists(23,'Shannon Watters');
call insert_comic_creator_if_not_exists(24,'Kelly Thompson');
call insert_comic_creator_if_not_exists(24,'Veronica Fish');
call insert_comic_creator_if_not_exists(25,'Joe Hill');
call insert_comic_creator_if_not_exists(25,'Gabriel Rodriguez');
call insert_comic_creator_if_not_exists(26,'Mike Mignola');
call insert_comic_creator_if_not_exists(27,'Noelle Stevenson');
call insert_comic_creator_if_not_exists(27,'Brooke Allen');
call insert_comic_creator_if_not_exists(28,'Denny ONeil');
call insert_comic_creator_if_not_exists(28,'Neal Adams');
call insert_comic_creator_if_not_exists(29,'Stan Lee');
call insert_comic_creator_if_not_exists(29,'Jack Kirby');
call insert_comic_creator_if_not_exists(30,'Frank Miller');
call insert_comic_creator_if_not_exists(31,'Neil Gaiman');
call insert_comic_creator_if_not_exists(32,'Alan Moore');
call insert_comic_creator_if_not_exists(32,'Dave Gibbons');
call insert_comic_creator_if_not_exists(33,'Stan Lee');
call insert_comic_creator_if_not_exists(33,'Steve Ditko');
call insert_comic_creator_if_not_exists(34,'Mike Mignola');
call insert_comic_creator_if_not_exists(35,'Joe Hill');
call insert_comic_creator_if_not_exists(35,'Gabriel Rodriguez');
call insert_comic_creator_if_not_exists(36,'Stan Lee');
call insert_comic_creator_if_not_exists(37,'Stan Lee');
call insert_comic_creator_if_not_exists(38,'Stan Lee');
call insert_comic_creator_if_not_exists(39,'Stan Lee');
call insert_comic_creator_if_not_exists(39,'John Romita Sr.');



-- Insert  comics
INSERT INTO comics (title, issue_number, release_date, series_id, type, edition, signed_by_creator, cover_date)
VALUES ('The Incredible Hulk', 1, '1962-05-01', GetSeriesIdByName('The Incredible Hulk'), 'Comic', 'First', FALSE, '1962-05-01'),
('Batman', 1, '1939-03-01', GetSeriesIdByName('Batman'), 'Comic', 'First', FALSE, '1939-03-01'),
('Spawn', 1, '1992-05-01', GetSeriesIdByName('Spawn'), 'Comic', 'First', FALSE, '1992-05-01'),
('Hellboy', 1, '1993-08-01', GetSeriesIdByName('Hellboy'), 'Comic', 'First', FALSE, '1993-03-01'),
('Batman', 1, '1973-09-01', GetSeriesIdByName('Batman'), 'Comic', 'First', FALSE, '1973-09-01'),
('Amazing Spider-Man', 50, '1967-07-01', GetSeriesIdByName('Spider-Man'), 'Comic', 'First', FALSE, '1967-07-01'),
('Teenage Mutant Ninja Turtles', 1, '2011-08-24', GetSeriesIdByName('Teenage Mutant Ninja Turtles'), 'Comic', 'First', FALSE, '2011-08-24'),
('Watchmen', 1, '1986-09-01', GetSeriesIdByName('Watchmen'), 'Comic', 'First', FALSE, '1986-09-01'),
('Hellboy: Seed of Destruction', 1, '1994-03-01', GetSeriesIdByName('Hellboy'), 'Comic', 'First', FALSE, '1994-03-01'),
('Daredevil', 1, '1964-04-01', GetSeriesIdByName('Daredevil'), 'Comic', 'First', FALSE, '1964-04-01'),
('Locke & Key: Welcome to Lovecraft', 1, '2008-02-20', GetSeriesIdByName('Locke & Key'), 'Comic', 'First', FALSE, '2008-02-20'),
('Watchmen', 1, '1986-09-01', GetSeriesIdByName('Watchmen'), 'Comic', 'First', FALSE, '1986-09-01'),
('X-Men', 1, '1963-09-01', GetSeriesIdByName('X-Men'), 'Comic', 'First', FALSE, '1963-09-01'),
('Hellboy', 6, '1994-05-01', GetSeriesIdByName('Hellboy'), 'Comic', 'First', FALSE, '1994-03-01'),
('Preacher', 1, '1995-04-01', GetSeriesIdByName('Preacher'), 'Comic', 'First', FALSE, '1995-04-01'),
('Locke & Key', 1, '2008-02-20', GetSeriesIdByName('Locke & Key'), 'Comic', 'First', FALSE, '2008-02-20'),
('Lumberjanes', 1, '2014-04-09', GetSeriesIdByName('Lumberjanes'), 'Comic', 'First', FALSE, '2014-04-09'),
('Hellboy', 1, '1994-03-23', GetSeriesIdByName('Hellboy'), 'Comic', 'First', FALSE, '1994-03-23'),
('X-O Manowar', 1, '1992-2-03', GetSeriesIdByName('X-O Manowar'), 'Comic', 'First', FALSE, '1992-2-03'),
('Teenage Mutant Ninja Turtles', 1, '2011-08-24', GetSeriesIdByName('Teenage Mutant Ninja Turtles'), 'Comic', 'First', FALSE, '2011-08-24'),
('Hellboy: Seed of Destruction', 1, '1994-03-09', GetSeriesIdByName('Hellboy'), 'Comic', 'First', FALSE, '1994-03-09'),
('X-O Manowar', 1, '1992-2-5', GetSeriesIdByName('X-O Manowar'), 'Comic', 'First', FALSE, '1992-2-5'),
('Lumberjanes', 1, '2014-04-09', GetSeriesIdByName('Lumberjanes'), 'Comic', 'First', FALSE, '2014-04-09'),
('Sabrina the Teenage Witch', 1, '2019-03-27', GetSeriesIdByName('Sabrina the Teenage Witch'), 'Comic', 'First', FALSE, '2019-03-27'),
('Locke & Key', 1, '2008-02-20', GetSeriesIdByName('Locke & Key'), 'Comic', 'First', FALSE, '2008-02-20'),
('Hellboy', 1, '1994-04-23', GetSeriesIdByName('Hellboy'), 'Comic', 'First', FALSE, '1994-03-23'),
('Lumberjanes', 1, '2014-04-09', GetSeriesIdByName('Lumberjanes'), 'Comic', 'First', FALSE, '2014-04-09'),
('Batman', 50, '1975-09-11', GetSeriesIdByName('Batman'), 'Comic', 'First', FALSE, '1973-09-11'),
('X-Men', 1, '1963-09-10', GetSeriesIdByName('X-Men'), 'Comic', 'First', FALSE, '1963-09-10'),
('Sin City', 1, '1991-04-01', GetSeriesIdByName('Sin City'), 'Comic', 'First', FALSE, '1991-04-01'),
('Sandman', 1, '1989-01-01', GetSeriesIdByName('Sandman'), 'Comic', 'First', FALSE, '1989-01-01'),
('Watchmen', 1, '1986-09-01', GetSeriesIdByName('Watchmen'), 'Comic', 'First', FALSE, '1986-09-01'),
('Spider-Man', 1, '1963-08-01', GetSeriesIdByName('Spider-Man'), 'Comic', 'First', FALSE, '1963-08-01'),
('Hellboy', 1, '1994-03-01', GetSeriesIdByName('Hellboy'), 'Comic', 'First', FALSE, '1994-03-01'),
('Locke & Key', 1, '2008-02-01', GetSeriesIdByName('Locke & Key'), 'Comic', 'First', FALSE, '2008-02-01'),
('The Incredible Hulk', 2, '1962-07-01', GetSeriesIdByName('The Incredible Hulk'), 'Comic', 'Standard', FALSE, '1962-07-01'),
('The Incredible Hulk', 3, '1962-09-01', GetSeriesIdByName('The Incredible Hulk'), 'Comic', 'Standard', FALSE, '1962-09-01'),
('The Incredible Hulk', 4, '1962-11-01', GetSeriesIdByName('The Incredible Hulk'), 'Comic', 'Standard', FALSE, '1962-11-01'),
('Amazing Spider-Man', 129, '1974-02-01', GetSeriesIdByName('Spider-Man'), 'Comic', 'First', FALSE, '1974-02-01');






-- Insert quality_mapping
INSERT INTO quality_mapping (comic_id, comics_condition, condition_number)
VALUES
(1, 'VG', 4.0),
(2, 'GD', 2.0),
(3, 'VF', 9.4),
(4, 'VF', 8.0),
(5, 'VG', 4.0),
(6, 'GD', 2.0),
(7, 'VF/NM', 9.0),
(8, 'VF', 8.0),
(9, 'NM', 9.5),
(10, 'FR', 0.5),
(11, 'NM', 9.4),
(12, 'VF', 8.5),
(13, 'VG', 4.5),
(14, 'VF', 8.0),
(15, 'FN', 6.0),
(16, 'NM', 9.2),
(17, 'VF/NM', 9.0),
(18, 'NM', 9.2),
(19, 'NM', 9.4),
(20, 'VF/NM', 9.0),
(21, 'NM', 9.4),
(22, 'VF/NM', 9.0),
(23, 'NM', 9.4),
(24, 'NM', 9.4),
(25, 'NM', 9.4),
(26, 'VF', 8.0),
(27, 'NM', 9.4),
(28, 'VG', 4.0),
(29, 'VG', 2.0),
(30, 'VF', 8.0),
(31, 'VF/NM', 9.0),
(32, 'NM', 9.4),
(33, 'GD', 2.0),
(34, 'VF', 8.0),
(35, 'NM', 9.4),
(36, 'GD', 2.0),
(37, 'GD', 2.0),
(38, 'VG', 4.0),
(39, 'VG', 4.0);




-- Insert an overstreet_price_guide records
INSERT INTO overstreet_price_guide (comic_id, year, Fair_price, Good_price, Very_good_price, Fine_price, Very_fine_price, Near_mint_price, Mint_price)
VALUES
(1, 2023, 10.00, 15.00, 20.00, 25.00, 30.00, 35.00, 40.00),
(2, 2023, 30.00, 40.00, 50.00, 60.00, 70.00, 80.00, 90.00),
(3, 2023, 50.00, 60.00, 70.00, 80.00, 90.00, 100.00, 110.00),
(4, 2023, 30.00, 40.00, 50.00, 60.00, 70.00, 80.00, 90.00),
(5, 2023, 10.00, 20.00, 30.00, 40.00, 50.00, 60.00, 70.00),
(6, 2023, 50.00, 80.00, 100.00, 120.00, 140.00, 160.00, 180.00),
(7, 2023, 10.00, 15.00, 20.00, 25.00, 30.00, 35.00, 40.00),
(8, 2023, 30.00, 40.00, 50.00, 60.00, 70.00, 80.00, 90.00),
(9, 2023, 30.00, 40.00, 50.00, 60.00, 70.00, 80.00, 90.00),
(10, 2023, 500.00, 750.00, 1000.00, 2000.00, 5000.00, 10000.00, 15000.00),
(11, 2023, 20.00, 30.00, 40.00, 60.00, 80.00, 120.00, 150.00),
(12, 2023, 150.00, 250.00, 350.00, 500.00, 750.00, 1200.00, 2000.00),
(13, 2023, 600.00, 1200.00, 1800.00, 2500.00, 4500.00, 7500.00, 12000.00),
(14, 2023, 90.00, 120.00, 150.00, 300.00, 450.00, 750.00, 1200.00),
(15, 2023, 25.00, 35.00, 50.00, 100.00, 150.00, 250.00, 400.00),
(16, 2023, 20.00, 30.00, 40.00, 80.00, 120.00, 200.00, 350.00),
(17, 2023, 10.00, 15.00, 20.00, 40.00, 60.00, 100.00, 175.00),
(18, 2023, 75.00, 100.00, 150.00, 200.00, 250.00, 350.00, 500.00),
(19, 2023, 20.00, 30.00, 45.00, 80.00, 120.00, 200.00, 350.00),
(20, 2023, 5.00, 10.00, 15.00, 25.00, 35.00, 50.00, 75.00),
(21, 2023, 300.00, 400.00, 500.00, 600.00, 800.00, 1200.00, 2000.00),
(22, 2023, 10.00, 20.00, 30.00, 50.00, 75.00, 125.00, 200.00),
(23, 2023, 10.00, 15.00, 20.00, 30.00, 50.00, 75.00, 100.00),
(24, 2023, 5.00, 8.00, 10.00, 15.00, 20.00, 30.00, 50.00),
(25, 2023, 30.00, 40.00, 60.00, 80.00, 100.00, 150.00, 200.00),
(26, 2023, 100.00, 150.00, 200.00, 300.00, 500.00, 750.00, 1000.00),
(27, 2023, 10.00, 15.00, 25.00, 35.00, 50.00, 75.00, 100.00),
(28, 2023, 35.00, 60.00, 100.00, 150.00, 250.00, 350.00, 500.00),
(29, 2023, 3000.00, 6000.00, 10000.00, 15000.00, 25000.00, 40000.00, 60000.00),
(30, 2023, 30.00, 50.00, 100.00, 150.00, 200.00, 300.00, 500.00),
(31, 2023, 50.00, 100.00, 200.00, 300.00, 400.00, 500.00, 800.00),
(32, 2023, 50.00, 75.00, 100.00, 150.00, 200.00, 300.00, 500.00),
(33, 2023, 500.00, 1000.00, 2500.00, 5000.00, 10000.00, 20000.00, 30000.00),
(34, 2023, 20.00, 30.00, 40.00, 60.00, 80.00, 120.00, 200.00),
(35, 2023, 15.00, 20.00, 25.00, 35.00, 50.00, 75.00, 100.00),
(36, 2023, 15.00, 20.00, 25.00, 35.00, 50.00, 75.00, 100.00),
(37, 2023, 15.00, 20.00, 25.00, 35.00, 50.00, 75.00, 100.00),
(38, 2023, 15.00, 20.00, 25.00, 35.00, 50.00, 75.00, 100.00),
(39, 2023, 10.00, 25.00, 30.00, 40.00, 55.00, 80.00, 105);




-- Insert prices
INSERT INTO prices (comic_id, purchase_price, sale_price, quality, last_updated)
VALUES
(1, 20.00, 25.00, 'VG', '2023-05-01'),
(2, 50.00, 60.00, 'GD', '2023-05-02'),
(3, 80.00, 100.00, 'VF', '2023-05-03'),
(4, 50.00, 80.00, 'VF', '2023-05-03'),
(5, 20.00, 40.00, 'VG', '2023-05-03'),
(6, 100.00, 200.00, 'GD', '2023-05-03'),
(7, 20.00, 40.00, 'VF/NM', '2023-05-03'),
(8, 50.00, 100.00, 'VF', '2023-05-03'),
(9, 60.00, 120.00, 'NM', '2023-05-03'),
(10, 1000.00, 5000.00, 'FR', '2023-05-03'),
(11, 40.00, 80.00, 'NM', '2023-05-03'),
(12, 250.00, 500.00, 'VF', '2023-05-03'),
(13, 500.00, 1000.00, 'VG', '2023-05-03'),
(14, 150.00, 300.00, 'VF', '2023-05-03'),
(15, 50.00, 100.00, 'FN', '2023-05-03'),
(16, 40.00, 80.00, 'NM', '2023-05-03'),
(17, 20.00, 40.00, 'VF/NM', '2023-05-03'),
(18, 200.00, 300.00, 'NM', '2023-05-03'),
(19, 80.00, 150.00, 'NM', '2023-05-03'),
(20, 10.00, 25.00, 'VF/20', '2023-05-03'),
(21, 500.00, 800.00, 'NM', '2023-05-03'),
(22, 25.00, 50.00, 'VF/NM', '2023-05-03'),
(23, 20.00, 50.00, 'NM', '2023-05-03'),
(24, 10.00, 20.00, 'NM', '2023-05-03'),
(25, 50.00, 100.00, 'NM', '2023-05-03'),
(26, 200.00, 500.00, 'VF', '2023-05-03'),
(27, 20.00, 40.00, 'NM', '2023-05-03'),
(28, 75.00, 150.00, 'VG', '2023-05-03'),
(29, 15000.00, 25000.00, 'VG', '2023-05-03'),
(30, 120.00, 200.00, 'VF', '2023-05-03'),
(31, 300.00, 600.00, 'VF/NM', '2023-05-03'),
(32, 200.00, 400.00, 'NM', '2023-05-03'),
(33, 2000.00, 5000.00, 'GD', '2023-05-03'),
(34, 100.00, 200.00, 'VF', '2023-05-03'),
(35, 50.00, 100.00, 'NM', '2023-05-03'),
(36, 15.00, 20.00, 'GD', '2023-05-01'),
(37, 15.00, 20.00, 'GD', '2023-05-01'),
(38, 20.00, 25.00, 'VG', '2023-05-01'),
(39, 20.00, 25.00, 'VG', '2023-05-01');













-- Insert another publishe;
CALL insert_publisher_if_not_exists ('DC Comics');
CALL insert_publisher_if_not_exists('Marvel Comics');
CALL insert_publisher_if_not_exists('Marvel Comics');
CALL insert_publisher_if_not_exists('Marvel Comics');
CALL insert_publisher_if_not_exists ('Marvel Comics');
CALL insert_publisher_if_not_exists('Marvel Comics');
CALL insert_publisher_if_not_exists ('Marvel Comics');
CALL insert_publisher_if_not_exists ('Marvel Comics');
CALL insert_publisher_if_not_exists ('Marvel Comics');
CALL insert_publisher_if_not_exists ('Marvel Comics');
CALL insert_publisher_if_not_exists ('Marvel Comics');
CALL insert_publisher_if_not_exists ('Marvel Comics');
CALL insert_publisher_if_not_exists ('Marvel Comics');
CALL insert_publisher_if_not_exists ('Marvel Comics');
CALL insert_publisher_if_not_exists ('DC Comics');
CALL insert_publisher_if_not_exists  ('DC Comics');
CALL insert_publisher_if_not_exists  ('DC Comics');
CALL insert_publisher_if_not_exists  ('DC Comics');
CALL insert_publisher_if_not_exists  ('DC Comics');
CALL insert_publisher_if_not_exists  ('DC Comics');
CALL insert_publisher_if_not_exists  ('Marvel Comics');
CALL insert_publisher_if_not_exists ('Marvel Comics');
CALL insert_publisher_if_not_exists ('Marvel Comics');
CALL insert_publisher_if_not_exists ('Marvel Comics');
CALL insert_publisher_if_not_exists('Marvel Comics');
CALL insert_publisher_if_not_exists('Marvel Comics');


-- Insert another series

CALL insert_series_if_not_exists ('Batman', 1940, 'DC Comics');
CALL insert_series_if_not_exists ('The Invincible Iron Man', 1968, 'Marvel Comics');
CALL insert_series_if_not_exists ('The Invincible Iron Man', 1968, 'Marvel Comics');
CALL insert_series_if_not_exists ('The Invincible Iron Man', 1968, 'Marvel Comics');
CALL insert_series_if_not_exists ('Daredevil', 1964, 'Marvel Comics');
CALL insert_series_if_not_exists ('Daredevil', 1964, 'Marvel Comics');
CALL insert_series_if_not_exists ('Daredevil', 1964, 'Marvel Comics');
CALL insert_series_if_not_exists ('The Amazing Spider-Man', 1963, 'Marvel Comics');
CALL insert_series_if_not_exists ('The Amazing Spider-Man', 1963,'Marvel Comics');
CALL insert_series_if_not_exists ('The Amazing Spider-Man', 1963, 'Marvel Comics');
CALL insert_series_if_not_exists ('The Amazing Spider-Man', 1963, 'Marvel Comics');
CALL insert_series_if_not_exists ('The Amazing Spider-Man', 1963, 'Marvel Comics');
CALL insert_series_if_not_exists ('The Amazing Spider-Man', 1963, 'Marvel Comics');
CALL insert_series_if_not_exists ('The Amazing Spider-Man', 1963,'Marvel Comics');
CALL insert_series_if_not_exists ('Superman', 1939, 'DC Comics');
CALL insert_series_if_not_exists ('Superman', 1939, 'DC Comics' );
CALL insert_series_if_not_exists('Batman', 1939, 'DC Comics' );
CALL insert_series_if_not_exists('Batman', 1939, 'DC Comics');
CALL insert_series_if_not_exists('Wonder Woman', 1941, 'DC Comics');
CALL insert_series_if_not_exists('Wonder Woman', 1941,'DC Comics');
CALL insert_series_if_not_exists ('Spider-Man', 1962, 'Marvel Comics');
CALL insert_series_if_not_exists ('Spider-Man', 1962, 'Marvel Comics' );
CALL insert_series_if_not_exists('Iron Man', 1963, 'Marvel Comics');
CALL insert_series_if_not_exists('Iron Man', 1963, 'Marvel Comics' );
CALL insert_series_if_not_exists('Thor', 1966, 'Marvel Comics');
CALL insert_series_if_not_exists('Thor', 1966, 'Marvel Comics');


-- Insert another creator

CALL insert_if_not_exists_creators ('Denny O''Neil', 'Writer', 'Denny O''Neil was an American comic book writer and editor, best known for his work on Batman, Green Arrow, and other DC Comics characters.');
CALL insert_if_not_exists_creators ('Neal Adams', 'Artist', 'Neal Adams is an American comic book artist, best known for his work on Batman, Green Lantern/Green Arrow, and other DC Comics characters.');
CALL insert_if_not_exists_creators ('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer. He rose through the ranks of a family-run business to become Marvel Comics primary creative leader.');
CALL insert_if_not_exists_creators       ('Larry Lieber', 'Writer', 'Larry Lieber is an American comic book writer and artist best known for his work in Marvel Comics, where he co-created Iron Man, Thor, and Ant-Man.');
CALL insert_if_not_exists_creators       ('Don Heck', 'Artist', 'Don Heck was an American comic book artist best known for co-creating the Marvel Comics characters Iron Man and the Wasp, and for his long run penciling The Avengers.');
CALL insert_if_not_exists_creators ('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer. He rose through the ranks of a family-run business to become Marvel Comics primary creative leader.');
CALL insert_if_not_exists_creators       ('Larry Lieber', 'Writer', 'Larry Lieber is an American comic book writer and artist best known for his work in Marvel Comics, where he co-created Iron Man, Thor, and Ant-Man.');
CALL insert_if_not_exists_creators       ('Don Heck', 'Artist', 'Don Heck was an American comic book artist best known for co-creating the Marvel Comics characters Iron Man and the Wasp, and for his long run penciling The Avengers.');
CALL insert_if_not_exists_creators ('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer. He rose through the ranks of a family-run business to become Marvel Comics primary creative leader.');
CALL insert_if_not_exists_creators       ('Larry Lieber', 'Writer', 'Larry Lieber is an American comic book writer and artist best known for his work in Marvel Comics, where he co-created Iron Man, Thor, and Ant-Man.');
CALL insert_if_not_exists_creators       ('Don Heck', 'Artist', 'Don Heck was an American comic book artist best known for co-creating the Marvel Comics characters Iron Man and the Wasp, and for his long run penciling The Avengers.');
CALL insert_if_not_exists_creators ('Frank Miller', 'Writer/Artist', 'Frank Miller is an American comic book writer, penciller and inker, novelist, and screenwriter best known for his work on Daredevil, Batman, and Sin City.');
CALL insert_if_not_exists_creators ('Gerry Conway', 'Writer', 'Gerry Conway is an American comic book writer known for co-creating the Marvel Comics character The Punisher and scripting the death of the character Gwen Stacy during his long run on The Amazing Spider-Man.');
CALL insert_if_not_exists_creators       ('Len Wein', 'Writer', 'Len Wein was an American comic book writer and editor best known for co-creating DC Comics'' Swamp Thing and Marvel Comics'' Wolverine, and for helping revive the Marvel superhero team the X-Men.');
CALL insert_if_not_exists_creators('Gerry Conway', 'Writer', 'Gerry Conway is an American comic book writer known for co-creating the Marvel Comics character The Punisher and scripting the death of the character Gwen Stacy during his long run on The Amazing Spider-Man.');
CALL insert_if_not_exists_creators       ('Len Wein', 'Writer', 'Len Wein was an American comic book writer and editor best known for co-creating DC Comics'' Swamp Thing and Marvel Comics'' Wolverine, and for helping revive the Marvel superhero team the X-Men.');
CALL insert_if_not_exists_creators ('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer. He co-created Spider-Man, the X-Men, Iron Man, Thor, the Hulk, Black Widow, the Fantastic Four, Black Panther, Daredevil, Doctor Strange, Scarlet Witch, and Ant-Man.');
CALL insert_if_not_exists_creators       ('Steve Ditko', 'Artist', 'Steve Ditko was an American comics artist and writer best known as the artist and co-creator, with Stan Lee, of the Marvel Comics superheroes Spider-Man and Doctor Strange.');
CALL insert_if_not_exists_creators ('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer. He co-created Spider-Man, the X-Men, Iron Man, Thor, the Hulk, Black Widow, the Fantastic Four, Black Panther, Daredevil, Doctor Strange, Scarlet Witch, and Ant-Man.');
CALL insert_if_not_exists_creators       ('Steve Ditko', 'Artist', 'Steve Ditko was an American comics artist and writer best known as the artist and co-creator, with Stan Lee, of the Marvel Comics superheroes Spider-Man and Doctor Strange.');
CALL insert_if_not_exists_creators ('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer. He co-created Spider-Man, the X-Men, Iron Man, Thor, the Hulk, Black Widow, the Fantastic Four, Black Panther, Daredevil, Doctor Strange, Scarlet Witch, and Ant-Man.');
CALL insert_if_not_exists_creators       ('Steve Ditko', 'Artist', 'Steve Ditko was an American comics artist and writer best known as the artist and co-creator, with Stan Lee, of the Marvel Comics superheroes Spider-Man and Doctor Strange.');
CALL insert_if_not_exists_creators ('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer. He co-created Spider-Man, the X-Men, Iron Man, Thor, the Hulk, Black Widow, the Fantastic Four, Black Panther, Daredevil, Doctor Strange, Scarlet Witch, and Ant-Man.');
CALL insert_if_not_exists_creators       ('Steve Ditko', 'Artist', 'Steve Ditko was an American comics artist and writer best known as the artist and co-creator, with Stan Lee, of the Marvel Comics superheroes Spider-Man and Doctor Strange.');
CALL insert_if_not_exists_creators ('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer. He co-created Spider-Man, the X-Men, Iron Man, Thor, the Hulk, Black Widow, the Fantastic Four, Black Panther, Daredevil, Doctor Strange, Scarlet Witch, and Ant-Man.');
CALL insert_if_not_exists_creators       ('Steve Ditko', 'Artist', 'Steve Ditko was an American comics artist and writer best known as the artist and co-creator, with Stan Lee, of the Marvel Comics superheroes Spider-Man and Doctor Strange.');;
CALL insert_if_not_exists_creators('Jerry Siegel', 'Writer', 'Jerry Siegel was an American comic book writer best known for co-creating the DC Comics character Superman with Joe Shuster.');
CALL insert_if_not_exists_creators('Joe Shuster', 'Artist', 'Joe Shuster was a Canadian-American comic book artist best known for co-creating the DC Comics character Superman with writer Jerry Siegel.');
CALL insert_if_not_exists_creators('Jerry Siegel', 'Writer', 'Jerry Siegel was an American comic book writer best known for co-creating the DC Comics character Superman with Joe Shuster.');
CALL insert_if_not_exists_creators('Joe Shuster', 'Artist', 'Joe Shuster was a Canadian-American comic book artist best known for co-creating the DC Comics character Superman with writer Jerry Siegel.');
CALL insert_if_not_exists_creators('Bob Kane', 'Artist', 'Bob Kane was an American comic book artist and writer, credited as the co-creator of the DC Comics character Batman.');
CALL insert_if_not_exists_creators('Bill Finger', 'Writer', 'Bill Finger was an American comic strip and comic book writer, credited as the co-creator of the DC Comics character Batman and the originator of Batman''s classic storylines.');
CALL insert_if_not_exists_creators('Bob Kane', 'Artist', 'Bob Kane was an American comic book artist and writer, credited as the co-creator of the DC Comics character Batman.');
CALL insert_if_not_exists_creators('Bill Finger', 'Writer', 'Bill Finger was an American comic strip and comic book writer, credited as the co-creator of the DC Comics character Batman and the originator of Batman''s classic storylines.');
CALL insert_if_not_exists_creators('William Moulton Marston', 'Writer', 'William Moulton Marston was an American psychologist and writer, best known for creating the DC Comics superhero Wonder Woman.');
CALL insert_if_not_exists_creators('William Moulton Marston', 'Writer', 'William Moulton Marston was an American psychologist and writer, best known for creating the DC Comics superhero Wonder Woman.');
CALL insert_if_not_exists_creators('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer, best known as the co-creator of many Marvel Comics characters, including Spider-Man, the X-Men, Iron Man, Thor, the Hulk, and Black Widow.');
CALL insert_if_not_exists_creators('Steve Ditko', 'Artist', 'Steve Ditko was an American comic book artist and writer, best known as the co-creator of the Marvel Comics characters Spider-Man and Doctor Strange.');
CALL insert_if_not_exists_creators('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer, best known as the co-creator of many Marvel Comics characters, including Spider-Man, the X-Men, Iron Man, Thor, the Hulk, and Black Widow.');
CALL insert_if_not_exists_creators('Steve Ditko', 'Artist', 'Steve Ditko was an American comic book artist and writer, best known as the co-creator of the Marvel Comics characters Spider-Man and Doctor Strange.');
CALL insert_if_not_exists_creators('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer, best known as the co-creator of many Marvel Comics characters, including Spider-Man, the X-Men, Iron Man, Thor, the Hulk, and Black Widow.');
CALL insert_if_not_exists_creators('Jack Kirby', 'Artist', 'Jack Kirby was an American comic book artist and writer, credited as the co-creator of many Marvel Comics characters, including the X-Men, Iron Man, Thor, the Hulk, and the Fantastic Four.');
CALL insert_if_not_exists_creators('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer, best known as the co-creator of many Marvel Comics characters, including Spider-Man, the X-Men, Iron Man, Thor, the Hulk, and Black Widow.');
CALL insert_if_not_exists_creators('Jack Kirby', 'Artist', 'Jack Kirby was an American comic book artist and writer, credited as the co-creator of many Marvel Comics characters, including the X-Men, Iron Man, Thor, the Hulk, and the Fantastic Four.');
CALL insert_if_not_exists_creators('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer, best known as the co-creator of many Marvel Comics characters, including Spider-Man, the X-Men, Iron Man, Thor, the Hulk, and Black Widow.');
CALL insert_if_not_exists_creators('Jack Kirby', 'Artist', 'Jack Kirby was an American comic book artist and writer, credited as the co-creator of many Marvel Comics characters, including the X-Men, Iron Man, Thor, the Hulk, and the Fantastic Four.');
CALL insert_if_not_exists_creators('Stan Lee', 'Writer', 'Stan Lee was an American comic book writer, editor, publisher, and producer, best known as the co-creator of many Marvel Comics characters, including Spider-Man, the X-Men, Iron Man, Thor, the Hulk, and Black Widow.');
CALL insert_if_not_exists_creators('Jack Kirby', 'Artist', 'Jack Kirby was an American comic book artist and writer, credited as the co-creator of many Marvel Comics characters, including the X-Men, Iron Man, Thor, the Hulk, and the Fantastic Four.');







-- Insert another character
CALL insert_character_if_not_exists('Batman');
CALL insert_character_if_not_exists('Iron Man');
CALL insert_character_if_not_exists('Iron Man');
CALL insert_character_if_not_exists('Iron Man');
CALL insert_character_if_not_exists('Daredevil');
CALL insert_character_if_not_exists('Daredevil');
CALL insert_character_if_not_exists('Daredevil');
CALL insert_character_if_not_exists('Spider-Man');
CALL insert_character_if_not_exists('Spider-Man');
CALL insert_character_if_not_exists('Spider-Man');
CALL insert_character_if_not_exists('Spider-Man');
CALL insert_character_if_not_exists('Spider-Man');
CALL insert_character_if_not_exists('Spider-Man');
CALL insert_character_if_not_exists('Spider-Man');
CALL insert_character_if_not_exists('Superman');
CALL insert_character_if_not_exists ('Superman');
CALL insert_character_if_not_exists ('Batman');
CALL insert_character_if_not_exists ('Batman');
CALL insert_character_if_not_exists ('Wonder Woman');
CALL insert_character_if_not_exists ('Wonder Woman');
CALL insert_character_if_not_exists ('Spider-Man');
CALL insert_character_if_not_exists ('Spider-Man');
CALL insert_character_if_not_exists ('Iron Man');
CALL insert_character_if_not_exists ('Iron Man');
CALL insert_character_if_not_exists ('Thor');
CALL insert_character_if_not_exists ('Thor');









-- Insert another comic_character

call insert_comic_character_if_not_exists(40,'Batman');
call insert_comic_character_if_not_exists(41,'Iron Man');
call insert_comic_character_if_not_exists(42,'Iron Man');
call insert_comic_character_if_not_exists(43,'Iron Man');
call insert_comic_character_if_not_exists(44,'Daredevil');
call insert_comic_character_if_not_exists(45,'Daredevil');
call insert_comic_character_if_not_exists(46,'Daredevil');
call insert_comic_character_if_not_exists(47,'Spider-Man');
call insert_comic_character_if_not_exists(48,'Spider-Man');
call insert_comic_character_if_not_exists(49,'Spider-Man');
call insert_comic_character_if_not_exists(50,'Spider-Man');
call insert_comic_character_if_not_exists(51,'Spider-Man');
call insert_comic_character_if_not_exists(52,'Spider-Man');
call insert_comic_character_if_not_exists(53,'Spider-Man');
call insert_comic_character_if_not_exists(54,'Superman');
call insert_comic_character_if_not_exists(55,'Superman');
call insert_comic_character_if_not_exists(56,'Batman');
call insert_comic_character_if_not_exists(57,'Batman');
call insert_comic_character_if_not_exists(58,'Wonder Woman');
call insert_comic_character_if_not_exists(59,'Wonder Woman');
call insert_comic_character_if_not_exists(60,'Spider-Man');
call insert_comic_character_if_not_exists(61,'Spider-Man');
call insert_comic_character_if_not_exists(62,'Iron Man');
call insert_comic_character_if_not_exists(63,'Iron Man');
call insert_comic_character_if_not_exists(64,'Thor');
call insert_comic_character_if_not_exists(65,'Thor');




-- Insert another comic_creator
call insert_comic_creator_if_not_exists(40, 'Denny O''Neil');
call insert_comic_creator_if_not_exists(40, 'Neal Adams');
call insert_comic_creator_if_not_exists(41, 'Stan Lee');
call insert_comic_creator_if_not_exists(41, 'Larry Lieber');
call insert_comic_creator_if_not_exists(41, 'Don Heck');
call insert_comic_creator_if_not_exists(42, 'Stan Lee');
call insert_comic_creator_if_not_exists(42, 'Larry Lieber');
call insert_comic_creator_if_not_exists(42, 'Don Heck');
call insert_comic_creator_if_not_exists(43, 'Stan Lee');
call insert_comic_creator_if_not_exists(43, 'Larry Lieber');
call insert_comic_creator_if_not_exists(43, 'Don Heck');
call insert_comic_creator_if_not_exists(44, 'Frank Miller');
call insert_comic_creator_if_not_exists(45, 'Gerry Conway');
call insert_comic_creator_if_not_exists(46, 'Len Wein');
call insert_comic_creator_if_not_exists(47, 'Gerry Conway');
call insert_comic_creator_if_not_exists(48, 'Len Wein');
call insert_comic_creator_if_not_exists(49, 'Stan Lee');
call insert_comic_creator_if_not_exists(49, 'Steve Ditko');
call insert_comic_creator_if_not_exists(50, 'Stan Lee');
call insert_comic_creator_if_not_exists(50, 'Steve Ditko');
call insert_comic_creator_if_not_exists(51, 'Stan Lee');
call insert_comic_creator_if_not_exists(51, 'Steve Ditko');
call insert_comic_creator_if_not_exists(52, 'Stan Lee');
call insert_comic_creator_if_not_exists(52, 'Steve Ditko');
call insert_comic_creator_if_not_exists(53, 'Stan Lee');
call insert_comic_creator_if_not_exists(53, 'Steve Ditko');
call insert_comic_creator_if_not_exists(54, 'Jerry Siegel');
call insert_comic_creator_if_not_exists(54, 'Joe Shuster');
call insert_comic_creator_if_not_exists(55, 'Jerry Siegel');
call insert_comic_creator_if_not_exists(55, 'Joe Shuster');
call insert_comic_creator_if_not_exists(56, 'Bob Kanes');
call insert_comic_creator_if_not_exists(56, 'Bill Finger');
call insert_comic_creator_if_not_exists(57, 'Bob Kanes');
call insert_comic_creator_if_not_exists(57, 'Bill Finger');
call insert_comic_creator_if_not_exists(58, 'William Moulton Marston');
call insert_comic_creator_if_not_exists(59, 'William Moulton Marston');
call insert_comic_creator_if_not_exists(60, 'Stan Lee');
call insert_comic_creator_if_not_exists(60, 'Steve Ditko');
call insert_comic_creator_if_not_exists(61, 'Stan Lee');
call insert_comic_creator_if_not_exists(61, 'Steve Ditko');
call insert_comic_creator_if_not_exists(62, 'Stan Lee');
call insert_comic_creator_if_not_exists(62, 'Jack Kirby');
call insert_comic_creator_if_not_exists(63, 'Stan Lee');
call insert_comic_creator_if_not_exists(63, 'Jack Kirby');
call insert_comic_creator_if_not_exists(64, 'Stan Lee');
call insert_comic_creator_if_not_exists(64, 'Jack Kirby');
call insert_comic_creator_if_not_exists(65, 'Stan Lee');
call insert_comic_creator_if_not_exists(65, 'Jack Kirby');








-- Insert another comic
INSERT INTO comics (title, issue_number, release_date, series_id, type, edition, signed_by_creator, cover_date)
values
('Batman', 85, '1976-09-11', GetSeriesIdByName('Batman'), 'Comic', 'First', FALSE, '1973-09-11'),
 ('The Invincible Iron Man', 10, '1969-01-01', GetSeriesIdByName('The Invincible Iron Man'), 'Comic', 'First', FALSE, '1969-01-01'),
('The Invincible Iron Man', 20, '1970-01-01',  GetSeriesIdByName('The Invincible Iron Man'),   'Comic', 'First', FALSE, '1970-01-01'),
('The Invincible Iron Man', 30, '1971-01-01',  GetSeriesIdByName('The Invincible Iron Man'),    'Comic', 'First', FALSE, '1971-01-01'),
 ('Daredevil', 158, '1980-05-01',   GetSeriesIdByName('Daredevil'),  'Comic','First', FALSE, '1980-05-01'),
('Daredevil', 159, '1980-06-01',  GetSeriesIdByName('Daredevil'),        'Comic',  'First', FALSE, '1980-06-01'),
('Daredevil', 160, '1980-07-01',GetSeriesIdByName('Daredevil'),       'Comic',  'First', FALSE, '1980-07-01'),
 ('The Amazing Spider-Man', 100, '1971-09-01',GetSeriesIdByName('The Amazing Spider-Man') ,  'Comic', 'First', FALSE, '1971-09-01'),
('The Amazing Spider-Man', 150, '1975-11-01', GetSeriesIdByName('The Amazing Spider-Man') ,   'Comic', 'First', TRUE, '1963-03-01'),
('The Amazing Spider-Man', 2, '1963-05-01',   GetSeriesIdByName('The Amazing Spider-Man') , 'Comic', 'First', TRUE, '1963-05-01'),
('The Amazing Spider-Man', 3, '1963-07-01',   GetSeriesIdByName('The Amazing Spider-Man') ,    'Comic', 'First', TRUE, '1963-07-01'),
('The Amazing Spider-Man', 4, '1963-09-01',   GetSeriesIdByName('The Amazing Spider-Man') ,     'Comic', 'First', TRUE, '1963-09-01'),
('The Amazing Spider-Man', 5, '1963-10-01',   GetSeriesIdByName('The Amazing Spider-Man') ,     'Comic', 'First', TRUE, '1963-10-01'),
('Superman: Birthright',20, '2003-09-17',     GetSeriesIdByName('Superman')   ,  'Graphic Novel', 'First', TRUE, '2003-09-17'),
('Superman: Red Son', 15, '2003-05-21',  GetSeriesIdByName('Superman')   ,  'Graphic Novel', 'Reprint', FALSE, '2003-05-21'),
('Batman: Year One', 16, '1987-02-12',         GetSeriesIdByName('Batman') ,   'Graphic Novel', 'First', TRUE, '1987-02-12'),
('Batman: The Dark Knight Returns',            GetSeriesIdByName('Batman') ,      '1986-02-01', 46, 'Graphic Novel', 'First', FALSE, '1986-02-01'),
('Wonder Woman: Earth One', 9, '2016-04-06',                   GetSeriesIdByName('Wonder Woman'),     'Graphic Novel', 'First', TRUE, '2016-04-06'),
('Wonder Woman:Gods and Mortals', 12, '1987-02-01',            GetSeriesIdByName('Wonder Woman'),   'Graphic Novel', 'First', FALSE, '1987-02-01'),
('The Amazing Spider-Man: The Complete Collection Vol. 1', 13, '2013-10-15',   GetSeriesIdByName('Spider-Man'),      'Graphic Novel', 'First', TRUE, '2013-10-15'),
('The Amazing Spider-Man: Kravens Last Hunt', 7, '1987-10-01',                 GetSeriesIdByName('Spider-Man'), 'Graphic Novel', 'First', FALSE, '1987-10-01'),
('Iron Man: Extremis', 2, '2006-03-29',                   GetSeriesIdByName('Iron Man'), 'Graphic Novel', 'First', TRUE, '2006-03-29'),
('Iron Man: Demon in a Bottle', 1, '1979-10-10',           GetSeriesIdByName('Iron Man'), 'Graphic Novel', 'First', FALSE, '1979-10-10'),
('Thor: God of Thunder Vol. 1', 3, '2013-07-10',        GetSeriesIdByName('Thor'),    'Graphic Novel', 'First', TRUE, '2013-07-10'),
('Thor: The Eternals Saga Vol. 1', 5, '1979-02-10',      GetSeriesIdByName('Thor'),    'Graphic Novel', 'Reprint', FALSE, '1979-02-10');




-- Insert another quality_mapping
INSERT INTO quality_mapping (comic_id, comics_condition, condition_number)
VALUES
(40, 'VG', 4.0),
(41, 'VG', 4.0),
 (42, 'VG', 4.0),
 (43, 'VG', 4.0),
 (44, 'VG', 4.0),
(45, 'VG', 4.0),
(46, 'VG', 4.0),
 (47, 'VG', 4.0),
(48, 'VG', 4.0),
 (49, 'VG', 4.0),
(50, 'VG', 4.0),
 (51, 'VG', 4.0),
(52, 'VG', 4.0),
 (53, 'VG', 4.0),
(54, 'NM', 9.4),
(55, 'VF', 8.0),
(56, 'VF', 8.0),
(57, 'VF', 8.0),
(58, 'NM', 9.4),
(59, 'VF', 8.0),
(60, 'NM', 9.4),
(61, 'VF', 8.0),
(62, 'NM', 9.4),
(63, 'VF', 8.0),
(64, 'NM', 9.4);
-- (65, 'VF', 8.0);


-- Insert another price
INSERT INTO prices (comic_id, purchase_price, sale_price, quality, last_updated)
VALUES (40, 75.00, 150.00, 'VG', '2023-05-03'),
 (41, 30.00, 30.00, 'VG', '2023-05-03'),
 (42, 35.00, 35.00, 'VG', '2023-05-03'),
(43, 35.00, 35.00, 'VG', '2023-05-03'),
 (44, 20.00, 25.00, 'VG', '2023-05-03'),
(45, 20.00, 25.00, 'VG', '2023-05-03'),
 (46, 20.00, 25.00, 'VG', '2023-05-03'),
 (47, 20.00, 40.00, 'VG', '2023-05-03'),
(48, 25.00, 50.00, 'VG', '2023-05-03'),
 (49, 20.00, 40.00, 'VG', '2023-05-03'),
(50, 25.00, 50.00, 'VG', '2023-05-03'),
(51, 30.00, 60.00, 'VG', '2023-05-03'),
(52, 35.00, 70.00, 'VG', '2023-05-03'),
(53, 40.00, 80.00, 'VG', '2023-05-03'),
(54, 150.00, 300.00, 'NM', '2023-05-05'),
(55, 50.00, 100.00, 'VF', '2023-05-05'),
(56, 75.00, 150.00, 'VF', '2023-05-05'),
(57, 100.00, 200.00, 'VF', '2023-05-05'),
(58, 200.00, 400.00, 'NM', '2023-05-05'),
(59, 30.00, 60.00, 'VF', '2023-05-05'),
(60, 250.00, 500.00, 'NM', '2023-05-05'),
(61, 40.00, 80.00, 'VF', '2023-05-05'),
(62, 175.00, 350.00, 'NM', '2023-05-05'),
(63, 25.00, 50.00, 'VF', '2023-05-05'),
(64, 100.00, 200.00, 'NM', '2023-05-05');



-- Insert another overstreet_price_guide record
INSERT INTO overstreet_price_guide (comic_id, year, Fair_price, Good_price, Very_good_price, Fine_price, Very_fine_price, Near_mint_price, Mint_price)
VALUES
(40, 2023, 35.00, 60.00, 100.00, 150.00, 250.00, 350.00, 500.00),
(41, 2023, 35.00, 60.00, 100.00, 150.00, 250.00, 350.00, 500.00),
(42, 2023, 35.00, 60.00, 100.00, 150.00, 250.00, 350.00, 500.00),
(43, 2023, 35.00, 60.00, 100.00, 150.00, 250.00, 350.00, 500.00),
 (44, 2023, 20.00, 30.00, 50.00, 75.00, 90.00, 100.00, 110.00),
(45, 2023, 20.00, 30.00, 50.00, 75.00, 90.00, 100.00, 110.00),
(46, 2023, 20.00, 30.00, 50.00, 75.00, 90.00, 100.00, 110.00),
(47, 2023, 10.00, 20.00, 30.00, 40.00, 50.00, 60.00, 70.00),
(48, 2023, 12.50, 25.00, 37.50, 50.00, 62.50, 75.00, 87.50),
(49, 2023, 10.00, 20.00, 30.00, 40.00, 50.00, 60.00, 70.00),
(50, 2023, 12.50, 25.00, 37.50, 50.00, 62.50, 75.00, 87.50),
 (51, 2023, 15.00, 30.00, 45.00, 60.00, 75.00, 90.00, 105.00),
(52, 2023, 17.50, 35.00, 52.50, 70.00, 87.50, 105.00, 122.50),
(53, 2023, 20.00, 40.00, 60.00, 80.00, 100.00, 120.00, 140.00),
(54, 2023, 120.00, 240.00, 360.00, 480.00, 600.00, 720.00, 840.00),
(55, 2023, 20.00, 40.00, 60.00, 80.00, 100.00, 120.00, 140.00),
(56, 2023, 30.00, 60.00, 90.00, 120.00, 150.00, 180.00, 210.00),
(57, 2023, 40.00, 80.00, 120.00, 160.00, 200.00, 240.00, 280.00),
(58, 2023, 180.00, 360.00, 540.00, 720.00, 900.00, 1080.00, 1260.00),
(59, 2023, 15.00, 30.00, 45.00, 60.00, 75.00, 90.00, 105.00),
(60, 2023, 300.00, 600.00, 900.00, 1200.00, 1500.00, 1800.00, 2100.00),
(61, 2023, 25.00, 50.00, 75.00, 100.00, 125.00, 150.00, 175.00),
(62, 2023, 150.00, 300.00, 450.00, 600.00, 750.00, 900.00, 1050.00),
(63, 2023, 20.00, 40.00, 60.00, 80.00, 100.00, 120.00, 140.00),
(64, 2023, 80.00, 160.00, 240.00,320.00, 400.00, 480.00, 560.00);



















-- VIEW_1 comic_value_info

CREATE VIEW comic_value_info AS
SELECT
    p.name AS Publisher,
    CONCAT(s.name, ' (', s.inception_year, ') (#', c.issue_number, ') (', p.name, ')') AS Title,
    c.issue_number AS Issue,
    opg.Fair_price AS Fair,
    opg.Good_price AS Good,
    opg.Very_good_price AS Very_Good,
    opg.Fine_price AS Fine,
    opg.Very_fine_price AS Very_Fine,
    opg.Near_mint_price AS Near_Mint,
    CASE
        WHEN c.signed_by_creator = TRUE THEN CONCAT( CAST(prices.quality AS CHAR), ' (Signed)')
        ELSE 'None'
    END AS Signed
FROM comics c
JOIN series s ON c.series_id = s.series_id
JOIN publishers p ON s.publisher_id = p.publisher_id
JOIN quality_mapping qm ON c.comic_id = qm.comic_id
JOIN prices ON c.comic_id = prices.comic_id
JOIN overstreet_price_guide opg ON c.comic_id = opg.comic_id
ORDER BY Title;

-- query for VIEW_1
SELECT Publisher, Title, Issue, Near_Mint
FROM comic_value_info
WHERE Publisher = 'Marvel Comics';






-- VIEW_2 Comics_Availability_View

CREATE VIEW comics_availability_view AS
SELECT
    p.name AS Publisher,
    CONCAT(s.name, ' (', s.inception_year, ') (#', c.issue_number, ') (', p.name, ')') AS Title,
    c.issue_number AS Issue,
    c.release_date AS Release_Date,
    c.type AS Type,
    c.edition AS Edition,
    c.cover_date AS Cover_Date,
    qm.comics_condition AS Quality,
    pr.sale_price AS Sale_Price,
    CASE
        WHEN pr.purchase_price IS NULL THEN 'Not Purchased'
        WHEN pr.sale_price IS NULL THEN 'Not for Sale'
        ELSE 'Available'
    END AS Status
FROM comics c
JOIN series s ON c.series_id = s.series_id
JOIN publishers p ON s.publisher_id = p.publisher_id
JOIN quality_mapping qm ON c.comic_id = qm.comic_id
JOIN prices pr ON c.comic_id = pr.comic_id
ORDER BY Title;


-- -- query for VIEW_2
SELECT Publisher, Title, Issue, Release_Date, Type, Edition, Cover_Date, Quality, Sale_Price, Status
FROM comics_availability_view
WHERE Status = 'Available' AND (Quality = 'VF' OR Quality = 'NM');







-- VIEW_3 view_comic_details
CREATE VIEW view_comic_details AS
SELECT
    p.name AS Publisher,
    CONCAT(s.name, ' (', s.inception_year, ') (#', c.issue_number, ') (', p.name, ')') AS Title,
    c.issue_number AS Issue,
    s.name AS series_name,
    GROUP_CONCAT(DISTINCT ch.name ORDER BY ch.name ASC SEPARATOR ', ') AS character_name,
    GROUP_CONCAT(DISTINCT cr.name ORDER BY cr.name ASC SEPARATOR ', ') AS creator_name
FROM comics c
JOIN series s ON c.series_id = s.series_id
JOIN publishers p ON s.publisher_id = p.publisher_id
JOIN comic_characters ch_c ON c.comic_id = ch_c.comic_id
JOIN characters ch ON ch_c.character_id = ch.character_id
JOIN comic_creators cc ON c.comic_id = cc.comic_id
JOIN creators cr ON cc.creator_id = cr.creator_id
GROUP BY c.comic_id, p.name, s.name, c.issue_number
ORDER BY Title;


--  query for VIEW_3
SELECT Publisher, Title, Issue, series_name, character_name, creator_name
FROM view_comic_details
WHERE character_name LIKE '%Batman%';






-- VIEW_4 top_10_valuable_comics
CREATE VIEW top_10_comics_by_sale_price AS
SELECT
    p.name AS Publisher,
    CONCAT(s.name, ' (', s.inception_year, ') (#', c.issue_number, ') (', p.name, ')') AS Title,
    c.issue_number AS Issue,
    s.name AS Series_Name,
    pr.sale_price AS Sale_Price,
    CASE
        WHEN c.signed_by_creator = TRUE THEN 'Signed'
        ELSE 'Not Signed'
    END AS Signed
FROM comics c
JOIN series s ON c.series_id = s.series_id
JOIN publishers p ON s.publisher_id = p.publisher_id
JOIN prices pr ON c.comic_id = pr.comic_id
ORDER BY pr.sale_price DESC
LIMIT 10;

--   query for VIEW_4
SELECT Publisher, Title, Issue, Series_Name, Sale_Price, Signed
FROM top_10_comics_by_sale_price;
























-- Queries:

-- Query1 for VIEW_1 comic_value_info:
-- Find all comics that have a Near Mint quality and are signed by the creator, sorted by publisher and title.
SELECT * FROM comic_value_info
WHERE Near_Mint IS NOT NULL AND Signed <> 'None'
ORDER BY Publisher, Title;

-- Query2 for VIEW_2 Comics_Availability_View:
-- Find all available comics for sale with a release date between '2000-01-01' and '2010-12-31', sorted by title.
SELECT * FROM comics_availability_view
WHERE Status = 'Available' AND Release_Date BETWEEN '2000-01-01' AND '2010-12-31'
ORDER BY Title;


-- Query3 for VIEW_3 view_comic_details:
-- Find all comics that have the character 'Daredevil' and the creator 'Frank Miller', sorted by publisher and title.
SELECT * FROM view_comic_details
WHERE character_name LIKE '%Daredevil%' AND creator_name LIKE '%Frank Miller%'
ORDER BY Publisher, Title;

-- Query4 for VIEW_4 top_10_valuable_comics:
-- Find the top 5 most valuable signed comics, sorted by sale price in descending order.
SELECT * FROM top_10_comics_by_sale_price
WHERE Signed = 'Not Signed'
ORDER BY Sale_Price DESC
LIMIT 5;



-- Special queries.


# 1.Find the earliest copy of The Incredible Hulk in good or better condition for less than $25.
SELECT comics.title, comics.issue_number, quality_mapping.comics_condition, prices.sale_price
FROM comics
JOIN quality_mapping ON comics.comic_id = quality_mapping.comic_id
JOIN prices ON comics.comic_id = prices.comic_id
WHERE comics.title = 'The Incredible Hulk'
AND quality_mapping.condition_number >= 2.2
AND prices.sale_price <= 25
ORDER BY comics.issue_number ASC;



# 2.Find how many issues of The Invincible Iron Man are in very good or better quality and can be purchased together for a total of $100 or less before issue 150.
SELECT COUNT(*) AS num_issues, SUM(prices.sale_price) AS total_price
FROM comics
JOIN quality_mapping ON comics.comic_id = quality_mapping.comic_id
JOIN prices ON comics.comic_id = prices.comic_id
WHERE comics.title = 'The Invincible Iron Man'
AND comics.issue_number < 150
AND quality_mapping.condition_number >= 4.0
HAVING total_price <= 100;



# 3.Find Daredevil issues written and drawn by Frank Miller in the 1980s.
SELECT c.title, c.issue_number , c.release_date , c.series_id, cs.name  FROM comics c
JOIN comic_creators cc ON c.comic_id = cc.comic_id
JOIN creators cs ON cc.creator_id = cs.creator_id
WHERE cs.name = 'Frank Miller' AND title = 'Daredevil' AND YEAR(release_date) BETWEEN 1980 AND 1989;



# 4.Find the comic where The Punisher first appeared.
SELECT c.*
FROM comics c
JOIN comic_characters cc ON c.comic_id = cc.comic_id
JOIN characters ch ON cc.character_id = ch.character_id
WHERE ch.name = 'The Punisher'
ORDER BY c.cover_date;





# 5. Find how many different writers worked on The Amazing Spider-Man in the 1970s.
SELECT COUNT(DISTINCT cr.creator_id) AS num_writers
FROM comics c
JOIN series s ON c.series_id = s.series_id
JOIN comic_creators cc ON c.comic_id = cc.comic_id
JOIN creators cr ON cc.creator_id = cr.creator_id
WHERE s.name = 'The Amazing Spider-Man'
AND cr.role = 'Writer'
AND YEAR(c.release_date) BETWEEN 1970 AND 1979;


# 6.Find the person who created Daredevil.

SELECT DISTINCT cr.*
FROM creators cr
JOIN comic_creators cc ON cr.creator_id = cc.creator_id
JOIN comics c ON cc.comic_id = c.comic_id
JOIN comic_characters ch_c ON c.comic_id = ch_c.comic_id
JOIN characters ch ON ch_c.character_id = ch.character_id
WHERE ch.name = 'Daredevil' or ch.name = 'The Punisher';


-- To search for comics by character, you can use the characters and comic_characters tables:
SELECT c.*
FROM comics c
JOIN comic_characters cc ON c.comic_id = cc.comic_id
JOIN characters ch ON cc.character_id = ch.character_id
WHERE ch.name = 'Batman';

-- To search by publisher, you can use the publishers table:
SELECT c.*
FROM comics c
JOIN series s ON c.series_id = s.series_id
JOIN publishers p ON s.publisher_id = p.publisher_id
WHERE p.name = 'DC Comics';















-- PL/SQL 3
-- The true selling price of a comic is determined by the quality of the comic and whether it is signed.

DELIMITER //

CREATE PROCEDURE update_sale_price(IN comic_id_param INT)
BEGIN
  DECLARE comic_condition DECIMAL(4,2);
  DECLARE signed_multiplier INT;
  DECLARE base_price DECIMAL(10,2);
  DECLARE new_sale_price DECIMAL(10,2);

  -- Get the comic condition from the quality_mapping table
  SELECT condition_number INTO comic_condition
  FROM quality_mapping
  WHERE comic_id = comic_id_param;

  -- Get the signed multiplier
  SELECT IF(signed_by_creator, 10, 1) INTO signed_multiplier
  FROM comics
  WHERE comic_id = comic_id_param;

  -- Get the base price from the overstreet_price_guide table
  SELECT
    CASE
      WHEN comic_condition <= 1.0 THEN Fair_price
      WHEN comic_condition <= 2.2 THEN Good_price
      WHEN comic_condition <= 4.0 THEN Very_good_price
      WHEN comic_condition <= 6.0 THEN Fine_price
      WHEN comic_condition <= 8.0 THEN Very_fine_price
      WHEN comic_condition <= 9.5 THEN Near_mint_price
      ELSE Mint_price
    END
  INTO base_price
  FROM overstreet_price_guide
  WHERE comic_id = comic_id_param;

  -- Set the sale_price according to the condition and whether the comic is signed
  SET new_sale_price = base_price * signed_multiplier;

  -- Update the sale_price in the prices table
  UPDATE prices
  SET sale_price = new_sale_price
  WHERE comic_id = comic_id_param;
END;
//

DELIMITER ;


-- update_sale_prices_in_range Update the prices of all the comics currently in the library.
DELIMITER //

CREATE PROCEDURE update_sale_prices_all()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE max_comic_id INT;

  -- Get the maximum comic_id from the comics table
  SELECT MAX(comic_id) INTO max_comic_id FROM comics;

  WHILE i <= max_comic_id DO
    CALL update_sale_price(i);
    SET i = i + 1;
  END WHILE;
END;
//

DELIMITER ;


-- CalculateProfitLoss

DELIMITER //
-- display the total profit and total loss
CREATE PROCEDURE CalculateProfitLoss()
BEGIN
  SELECT c.title, c.issue_number, p.purchase_price, p.sale_price, (p.sale_price - p.purchase_price) AS profit_loss
  FROM comics c
  JOIN prices p ON c.comic_id = p.comic_id;
END;
//
DELIMITER ;





-- TRIGGERS

 -- TRIGGERS After updating the sales price, add the current system update time.

DELIMITER //
CREATE TRIGGER update_last_updated
BEFORE UPDATE ON prices
FOR EACH ROW
BEGIN
  IF OLD.sale_price <> NEW.sale_price THEN
    SET NEW.last_updated = NOW();
  END IF;
END;
//
DELIMITER ;













-- After completing the above queries then run the following test.

--  TEST PROCEDURE and  TRIGGER


--  1.TEST PROCEDURE update_sale_price and see the effect of the trigger
-- Before update

-- select * from prices where comic_id = 1;
-- call  update_sale_price(1);

-- After update
-- select  * from prices where comic_id = 1;

--  2.TEST PROCEDURE  update_sale_prices_in_range

-- call update_sale_prices_all();


-- 3.TEST PROCEDURE CalculateProfitLoss
-- call CalculateProfitLoss();


-- 4. TEST TRIGGER
-- UPDATE prices
-- SET last_updated = '2022-05-01'
-- WHERE comic_id = 1;

-- SELECT * FROM  prices where comic_id = 1;

-- UPDATE prices
-- SET sale_price = 50
-- WHERE comic_id = 1;

-- SELECT * FROM  prices where comic_id = 1;



