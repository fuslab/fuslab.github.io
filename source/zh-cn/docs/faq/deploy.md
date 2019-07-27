title: JDP环境及部署问题汇总
---

## 1. Superset: `Error: libmysqlclient.so.20: cannot open shared object file: No such file or directory"`

```
yum install python-devel mysql-devel
```

操作系统缺包导致如上问题。

## 2. Superset: `Error: 'utf8' codec can't decode byte 0x85 in position 561: invalid start byte`

```
supserset: mysql://root:a123456@192.168.0.25:3306/SE?charset=utf8
```
