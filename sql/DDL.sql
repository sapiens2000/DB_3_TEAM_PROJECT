CREATE TABLE USERS(
    User_id                 VARCHAR(20) NOT NULL,
    Upassword               VARCHAR(20) NOT NULL,
    Unum                    NUMBER      NOT NULL,
    Ucurrent_total_asset    NUMBER      DEFAULT 10000000,
    Ucash                   NUMBER      DEFAULT 10000000,
    Uage                    NUMBER,
    Usex                    CHAR,
    Uemail                  VARCHAR(30),
    Ucell_phone_number      VARCHAR(13),
    PRIMARY KEY (User_id),
    UNIQUE(Unum)
);

CREATE TABLE STOCK(
    Scode VARCHAR(6)    NOT NULL,
    Sname VARCHAR(30)   NOT NULL,
    Smarket             NUMBER,
    Smarket_cap         NUMBER,
    Sforeign_rate       NUMBER(4,2),
    Sper                NUMBER(7,2)    DEFAULT NULL,
    Spbr                NUMBER(7,2)    DEFAULT NULL,
    Sroe                NUMBER(7,2)    DEFAULT NULL,
    Supdate_date        DATE DEFAULT NULL,
    PRIMARY KEY (Scode),
    UNIQUE(Sname)
);

CREATE TABLE CHART(
    Ccode                   VARCHAR(6)  NOT NULL,
    Cstart_date             DATE        NOT NULL,
    Cend_date               DATE,
    Cstart_price            NUMBER,
    Chigh_price             NUMBER,
    Clow_price              NUMBER,
    Cclose_price            NUMBER,
    Cscale                  CHAR,
    Crate_of_fluctuation    NUMBER(3,2),
    PRIMARY KEY (Ccode, Cscale, Cstart_date)
);

CREATE TABLE SECTOR( 
    Sector_name VARCHAR(20) NOT NULL,   
    Scode       VARCHAR(6)  NOT NULL,
    Sname       VARCHAR(30) NOT NULL,
    PRIMARY KEY (Scode, Sector_name)
);

CREATE TABLE RANKING(
    Ruser_id    VARCHAR(20) NOT NULL,
    Rank        NUMBER,
    PRIMARY KEY (Ruser_id, RANK)
);

CREATE TABLE NEWS(
    Nwhen   DATE                NOT NULL,
    Ntitle  VARCHAR(1000)       NOT NULL,
    Nurl    VARCHAR(1000)       NOT NULL,
    Ncompany VARCHAR(20)        NOT NULL,
    PRIMARY KEY (Nurl)
);

CREATE TABLE TRANSACTION_LIST(
    Tnum    NUMBER      NOT NULL,
    Twhen   DATE        NOT NULL,
    Tname   VARCHAR(30) NOT NULL,
    Type   VARCHAR(4)  NOT NULL,
    Tvalue  NUMBER      NOT NULL,
    Tvolume NUMBER      NOT NULL,
    PRIMARY KEY (Tnum)
);

CREATE TABLE INTEREST(
    In_unum     NUMBER      NOT NULL,
    In_scode    VARCHAR(6)  NOT NULL,
    Quantity    NUMBER,
    Item_assets NUMBER,
    PRIMARY KEY (In_unum, In_scode)

);


CREATE TABLE HISTORY(
    Hunum       NUMBER      NOT NULL,
    Htnum       NUMBER      NOT NULL,
    PRIMARY KEY (Hunum, Htnum)

);

CREATE TABLE MENTION(
    Mcode   VARCHAR(6)      NOT NULL,
    Murl    VARCHAR(1000)   NOT NULL,
    PRIMARY KEY (Mcode, Murl)

);

ALTER TABLE INTEREST ADD FOREIGN KEY(In_scode) REFERENCES STOCK(Scode);
ALTER TABLE INTEREST ADD FOREIGN KEY (In_unum) REFERENCES USERS(Unum);
ALTER TABLE HISTORY ADD FOREIGN KEY (Htnum) REFERENCES TRANSACTION_LIST(Tnum);
ALTER TABLE SECTOR ADD FOREIGN KEY (Scode) REFERENCES STOCK(Scode);
ALTER TABLE MENTION ADD FOREIGN KEY (Murl) REFERENCES NEWS(Nurl);

commit;

