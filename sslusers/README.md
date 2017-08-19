# Basic Template

Based on Ray Wenderlich's screencast **Server Side Swift with Vapor: Registering Users over SSL**

## 📖 Documentation

Ses video [video](https://videos.raywenderlich.com/screencasts/624-server-side-swift-with-vapor-registering-users-over-ssl) for more details.

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

