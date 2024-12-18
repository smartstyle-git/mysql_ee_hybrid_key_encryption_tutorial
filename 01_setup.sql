-- Create schema and tables

create schema keystore;
create schema appdata;

create table appdata.tab(id int primary key, secretkey_id int, secret varbinary(3000) not null);
create table keystore.tab$secretkey(id int primary key, secretkey varbinary(3000) not null, publickey_id int not null);
create table keystore.publickey(id int primary key, publickey varbinary(3000) not null, is_active tinyint(1) default 0 not null);
create table keystore.privatekey(id int primary key, privatekey varbinary(3000) not null, publickey_id int not null);

-- Create user
create user trusted     identified by 'MySQL8.4'; -- trusted user
create user non_trusted identified by 'MySQL8.4'; -- normal user

-- Grant privileges
grant all on keystore.* to trusted;
grant all on appdata.* to trusted;

grant select,insert,update,delete on appdata.tab to non_trusted;
grant select on keystore.publickey to non_trusted;
grant insert on keystore.tab$secretkey to non_trusted;

-- Create RSA keypair
set @key_len = 2048;
set @algo = 'RSA';
set @priv = CREATE_ASYMMETRIC_PRIV_KEY(@algo, @key_len);
set @pub = CREATE_ASYMMETRIC_PUB_KEY(@algo, @priv);
select @pub, @priv\G
insert into keystore.publickey values (1, @pub, TRUE);
insert into keystore.privatekey values (1, @priv, 1);
