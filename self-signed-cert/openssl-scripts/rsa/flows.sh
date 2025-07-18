echo "my secret message" > secret.txt

# Encrypt
openssl pkeyutl -encrypt -inkey public.key -pubin -in secret.txt -out secret.enc

# Decrypt
openssl pkeyutl -decrypt -inkey private.key -in secret.enc -out decrypted.txt


----- 
# now encript with priv and decrypt with pub
openssl dgst -sha256 -sign rootCA.key -out secret.sig secret.txt


openssl dgst -sha256 -verify rootCA.pub -signature secret.sig secret.txt
---
extract pub key from certifictate
openssl x509 -in rootCA.crt -pubkey -noout > rootCA.pub
---
full
openssl x509 -in rootCA.crt -text -noout
---
full for csr
openssl req -in request.csr -text -noout
