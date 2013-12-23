on.parkr.me

url shortener for parker because he has no idea what else to do with this domain
name

### Setup on Dokku

This assumes you have [dokku][] and [dokku-md-plugin][] (MariaDB) installed.

[dokku]: https://github.com/progrium/dokku
[dokku-md-plugin]: https://github.com/Kloadut/dokku-md-plugin

```bash
git remote add dokku dokku@$DOKKU_HOST:on
git push dokku master
ssh dokku@$DOKKU_HOST -t "dokku mariadb:create on"
ssh dokku@$DOKKU_HOST -t "dokku run on 'script/setup_database'"
```

This will create the app, create a MariaDB container for it, and setup the
database. Now just send requests to the server as you would any other guillotine
app.
