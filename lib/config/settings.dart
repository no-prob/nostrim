Map<String, String> relaySettings = {
  'nostr_relay': 'ws://192.168.50.162:6969',
  'monstr_relay': 'ws://127.0.0.1:8081',
};

// XXX JUNK DEBUG
String getKey(String user, String key) {
    Map<String, dynamic> keys = {
        'bob': {
            'pub': '2d38a56c4303bc722370c50c86fc8dd3327f06a8fe59b3ff3d670738d71dd1e1',
            'priv': '826ef0e93c1278bd89945377fadb6b6b51d9eedf74ecdb64a96f1897bb670be8',
         },
        'alice': {
            'pub': '0f76c800a7ea76b83a3ae87de94c6046b98311bda8885cedd8420885b50de181',
            'priv': '773dc29ff81f7680eeca5d530f528e8c572979b46abc8bfd1586b73a6a98ab4d',
        },
    };
    return keys[user][key];
}


