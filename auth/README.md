# Basic Template

Based on Ray Wenderlich's screencast **Server Side Swift with Vapor: Authentication with Turnstile**

## 📖 Documentation

Ses video [video](https://videos.raywenderlich.com/screencasts/637-server-side-swift-with-vapor-authentication-with-turnstile) for more details.

# Linux generate p12 certificate:

```/bin/sh
    openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem
```

```/bin/sh
    openssl x509 -text -noout -in certificate.pem
```

```/bin/sh
    openssl pkcs12 -inkey key.pem -in certificate.pem -export -out certificate.p12
```

