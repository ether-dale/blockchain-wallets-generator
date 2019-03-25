#include "common.h"
#include "hash.h"

#include <openssl/bn.h>
#include <openssl/ec.h>
#include <openssl/obj_mac.h>
#include <openssl/ecdsa.h>
#include <openssl/ripemd.h>

#include <string.h>

EC_KEY *bbp_ec_new_keypair(const uint8_t *priv_bytes)
{
    EC_KEY *key;
    BIGNUM *priv;
    BN_CTX *ctx;
    const EC_GROUP *group;
    EC_POINT *pub;

    /* init empty OpenSSL EC keypair */

    key = EC_KEY_new_by_curve_name(NID_secp256k1);

    /* set private key through BIGNUM */

    priv = BN_new();
    BN_bin2bn(priv_bytes, 32, priv);
    EC_KEY_set_private_key(key, priv);

    /* derive public key from private key and group */

    ctx = BN_CTX_new();
    BN_CTX_start(ctx);

    group = EC_KEY_get0_group(key);
    pub = EC_POINT_new(group);
    EC_POINT_mul(group, pub, priv, NULL, NULL, ctx);
    EC_KEY_set_public_key(key, pub);

    /* release resources */
    EC_POINT_free(pub);
    BN_CTX_end(ctx);
    BN_CTX_free(ctx);
    BN_clear_free(priv);

    return key;
}

int main(int argc, char *argv[])
{
    char *pr = argv[1];

    uint8_t priv_bytes[32];

    pr += 2;
    char s[3];
    s[2] = '\0';
    for (int i = 0; i < 32; ++i)
    {
        s[0] = *pr;
        ++pr;
        s[1] = *pr;
        ++pr;
        priv_bytes[i] = (uint8_t)strtol(s, NULL, 16);
    }

    EC_KEY *key;
    uint8_t priv[32];
    uint8_t *pub;
    const BIGNUM *priv_bn;
    const EC_POINT *pub_p;

    point_conversion_form_t conv_forms[] = {
        POINT_CONVERSION_UNCOMPRESSED,
        POINT_CONVERSION_COMPRESSED};
    const char *conv_forms_desc[] = {
        "uncompressed",
        "compressed"};

    /* create keypair */
    key = bbp_ec_new_keypair(priv_bytes);
    if (!key)
    {
        puts("Unable to create keypair");
        return -1;
    }

    /* get private key back from EC_KEY */
    priv_bn = EC_KEY_get0_private_key(key);
    if (!priv_bn)
    {
        puts("Unable to decode private key");
        return -1;
    }

    pub_p = EC_KEY_get0_public_key(key);

    BN_bn2bin(priv_bn, priv);

    const EC_GROUP *ec_group;
    ec_group = EC_KEY_get0_group(key);

    char *encoded = EC_POINT_point2hex(
        ec_group,
        pub_p,
        POINT_CONVERSION_UNCOMPRESSED,
        NULL);

    char subbuff[64];
    memcpy(subbuff, &encoded[2], 64);
    subbuff[64] = '\0';

    encoded += 129;

    char str[2] = {0};
    str[0] = *encoded;

    long num = strtol(str, NULL, 16);

    char pub_key[66];
    pub_key[66] = '\0';
    pub_key[0] = '0';
    pub_key[1] = num % 2 == 0 ? '2' : '3';

    for (int i = 2; i < 66; i++)
    {
        pub_key[i] = subbuff[i - 2];
    }

    printf("%s", pub_key);

    return 0;
}