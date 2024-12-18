use keystore
select privatekey from privatekey priv inner join publickey pub on priv.publickey_id = pub.id and pub.is_active = TRUE limit 1 into @privkey;
set @key_len = 2048;
set @algo = 'RSA';
select cast(aes_decrypt(t.secret, asymmetric_decrypt(@algo, sec.secretkey, @privkey)) as char) from appdata.tab t inner join keystore.tab$secretkey sec on t.secretkey_id = sec.id;
