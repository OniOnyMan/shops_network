### How to build that: 
1. Execute "shops_network.sql" in ur database
2. Check that PHP support and Apache on ur server is greater than v7.1
3. Run following commands in project folder:

```
composer install
composer self-update
composer dump-autoload
yarn
yarn run watch-poll
```
or
```
yarn run dev
```
