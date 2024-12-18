use keystore;

-- アクティブな公開鍵を取得
select id, publickey from publickey where is_active = TRUE limit 1 into @pubkey_id, @pubkey;
select @pubkey_id, @pubkey;

-- ランダムなパスフレーズを毎回生成
-- パスフレーズの存続期間はセキュリティ要件に合わせて調整します
-- パスフレーズを永続化ファイルに記録することは共通鍵暗号方式と同様の問題が懸念されるため強くおすすめしません
set @passphrase = SHA2(lpad(conv(floor(rand()*pow(36,8)),10,36),8,0),224);
select @passphrase;

-- 暗号化対象データ
set @plain_text = 'foo bar baz';
select @plain_text;

-- 暗号化
set @cipher_text = aes_encrypt(@plain_text, @passphrase);
select @cipher_text;

-- パスフレーズを公開鍵で暗号化
set @key_len = 2048;
set @algo = 'RSA';
set @enc_pp = asymmetric_encrypt(@algo, @passphrase, @pubkey);
select hex(@enc_pp)\G

begin;
-- 暗号化したパスフレーズを登録
insert into tab$secretkey values (1, @enc_pp, @pubkey_id);

-- 暗号化データをINSERT
insert into appdata.tab values (1, 1, @cipher_text);
commit;

-- 暗号化データの表示
select id, secretkey_id, hex(secret) from appdata.tab\G

-- 登録処理の終了
exit;
