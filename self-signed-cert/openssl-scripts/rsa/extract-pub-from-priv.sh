# $1 = priv key name
# $2 = pub key name
# extract from rsa private key
openssl rsa -in $1 -pubout -out $2