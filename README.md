# b3c-data-mysql

B3 Companion MySQL DDL module

![B3C Data Schema](https://github.com/jarismar/b3c-data-mysql/blob/main/mysql-schema.png)

# Backup using mysqldump

```
mysqldump -h $mysql_host -u $mysql_backup_admin -p $b3c_squema > $dump_file
```
