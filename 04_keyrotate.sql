-- for RSA
set @key_len = 2048;
set @algo = 'RSA';

-- Create new keypair
set @new_priv = CREATE_ASYMMETRIC_PRIV_KEY(@algo, @key_len);
set @new_pub = CREATE_ASYMMETRIC_PUB_KEY(@algo, @new_priv);
select @new_pub, @new_priv\G

-- Store new keypair
select max(id)+1 into @new_pubid from keystore.publickey;
select max(id)+1 into @new_privid from keystore.privatekey;
select @new_pubid, @new_privid;
insert into keystore.publickey values (@new_pubid, @new_pub, FALSE);
insert into keystore.privatekey values (@new_privid, @new_priv, @new_pubid);

-- Get current private key
select privatekey from keystore.privatekey priv inner join keystore.publickey pub on priv.publickey_id = pub.id and pub.is_active = TRUE limit 1 into @old_privkey;

-- Switch active key
begin;
update keystore.publickey set is_active = FALSE where is_active = TRUE; 
update keystore.publickey set is_active = TRUE where id = @new_pubid; 
commit;

-- Re-encryption
update keystore.tab$secretkey sec inner join keystore.privatekey priv on sec.publickey_id = priv.publickey_id set sec.secretkey = asymmetric_encrypt(@algo, asymmetric_decrypt(@algo, sec.secretkey, priv.privatekey), @new_pub), sec.publickey_id = @new_pubid where sec.publickey_id != @new_pubid;

-- Show test data
select cast(aes_decrypt(t.secret, asymmetric_decrypt(@algo, sec.secretkey, @new_priv)) as char) from appdata.tab t inner join keystore.tab$secretkey sec on t.secretkey_id = sec.id;
