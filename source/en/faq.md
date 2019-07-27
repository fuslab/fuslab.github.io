title: FAQ
---

## 1. Superset: `Error: libmysqlclient.so.20: cannot open shared object file: No such file or directory"`

```
yum install python-devel mysql-devel
```

## 2. Superset: `Error: 'utf8' codec can't decode byte 0x85 in position 561: invalid start byte`

```
supserset: mysql://root:a123456@192.168.0.25:3306/SE?charset=utf8
```

## 3. 关于 superset 连接 mysql 数据源的问题

```
Error: {"error":"Connection failed! The error message returned was:libmysqlclient.so.20: cannot open shared object file: No such file or directory"}
```

该错误提示找不到 libmysqlclient.so.20 该文件

这里基于Centos 7.x 系统

解决方法:

CentOs 7.x 默认的是 mariadb 而非 mysql, 直接执行 yum -y install mysql-devel 不能解决问题。首先卸载已安装的 mariadb 包。

- 查找  `rpm -qa|grep mariadb`
- 卸载  `rpm -e --nodeps mariadb-libs-5.5.60-1.el7_5.x86_64`


方案一、在线yum源的安装:

- 下载rpm包：

```
wget http://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm   
```

- 软件升级：

```
rpm -Uvh mysql57-community-release-el7-11.noarch.rpm
```

- 安装 mysql-devel

```
yum install -y mysql-devel
```

方案二、离线yum源的安装:

- 下载依赖所有的rpm包:

在`https://dev.mysql.com/downloads/mysql/`选择为`Red Hat Enterprise Linux 7 `/ `Oracle Linux 7` ，把`os`的版本选择为`all`。直接下载  `mysql-5.7.27-1.el7.x86_64.rpm-bundle.tar`，所有的rpm包都在里面。

- 解压tar包

```
tar -xf mysql-5.7.27-1.el7.x86_64.rpm-bundle.tar
```

解压后包含以下文件：

```
mysql-community-client-5.7.27-1.el7.x86_64.rpm
mysql-community-devel-5.7.27-1.el7.x86_64.rpm
mysql-community-common-5.7.27-1.el7.x86_64.rpm      
mysql-community-embedded-5.7.27-1.el7.x86_64.rpm
mysql-community-embedded-compat-5.7.27-1.el7.x86_64.rpm
mysql-community-embedded-devel-5.7.27-1.el7.x86_64.rpm
mysql-community-libs-compat-5.7.27-1.el7.x86_64.rpm
mysql-community-libs-5.7.27-1.el7.x86_64.rpm
mysql-community-server-5.7.27-1.el7.x86_64.rpm
mysql-community-test-5.7.27-1.el7.x86_64.rpm
```

安装我们所需的安装包：这里只需要安装 mysql-devel

```
            rpm -ivh mysql-community-common-5.7.27-1.el7.x86_64.rpm
            rpm -ivh mysql-community-libs-5.7.27-1.el7.x86_64
            rpm -ivh mysql-community-devel-5.7.27-1.el7.x86_64
```

指定 yum 命令

```
yum install -y mysql-devel
```

至此两种方法解决 superset 连接 mysql， 提示缺少 `libmysqlclient.so.20` 的错误问题。

## 4. 无法打开 Superset Web 界面的问题

```
    [2019-07-19 22:25:57,934] ERROR in app: Exception on /superset/welcome [GET]
    Traceback (most recent call last):
    File "/usr/jdp/current/superset/lib/python2.7/site-packages/flask/app.py", line 1982, in wsgi_app
        response = self.full_dispatch_request()
    File "/usr/jdp/current/superset/lib/python2.7/site-packages/flask/app.py", line 1615, in full_dispatch_request
        return self.finalize_request(rv)
    File "/usr/jdp/current/superset/lib/python2.7/site-packages/flask/app.py", line 1632, in finalize_request
        response = self.process_response(response)
    File "/usr/jdp/current/superset/lib/python2.7/site-packages/flask/app.py", line 1858, in process_response
        self.save_session(ctx.session, response)
    File "/usr/jdp/current/superset/lib/python2.7/site-packages/flask/app.py", line 924, in save_session
        return self.session_interface.save_session(self, session, response)
    File "/usr/jdp/current/superset/lib/python2.7/site-packages/flask/sessions.py", line 363, in save_session
        val = self.get_signing_serializer(app).dumps(dict(session))
    File "/usr/jdp/current/superset/lib/python2.7/site-packages/itsdangerous/serializer.py", 
    line 167, in dumps rv = self.make_signer(salt).sign(payload)
    File "/usr/jdp/current/superset/lib/python2.7/site-packages/itsdangerous/timed.py", 
    line 42, in sign return value + sep + self.get_signature(value)
    File "/usr/jdp/current/superset/lib/python2.7/site-packages/itsdangerous/signer.py", line 143, in get_signature key = self.derive_key()
    File "/usr/jdp/current/superset/lib/python2.7/site-packages/itsdangerous/signer.py", line 132, in derive_key
        mac = hmac.new(self.secret_key, digestmod=self.digest_method)
    File "/usr/lib64/python2.7/hmac.py", line 136, in new
        return HMAC(key, msg, digestmod)
    File "/usr/lib64/python2.7/hmac.py", line 71, in __init__
        if len(key) > blocksize:
    TypeError: object of type 'int' has no len()
    [2019-07-19 22:25:57,941] ERROR in app: Request finalizing failed with an error while handling an error
    Traceback (most recent call last):
    File "/usr/jdp/current/superset/lib/python2.7/site-packages/flask/app.py", line 1632, in finalize_request
        response = self.process_response(response)
    File "/usr/jdp/current/superset/lib/python2.7/site-packages/flask/app.py", line 1858, in process_response
        self.save_session(ctx.session, response)
    File "/usr/jdp/current/superset/lib/python2.7/site-packages/flask/app.py", line 924, in save_session
        return self.session_interface.save_session(self, session, response)
    File "/usr/jdp/current/superset/lib/python2.7/site-packages/flask/sessions.py", line 363, in save_session
        val = self.get_signing_serializer(app).dumps(dict(session))
```

错误原因是: Superset Secret Password 密码设置过于简单，为纯数字。密码格式：请输入带有数字和字符的密码信息。

## 5. 离线 YUM 源安装 Hadoop 服务失败

```
RuntimeError: Failed to execute command '/usr/bin/yum -y install hadoop_3_2_0_0_108-client', exited with code '1', message: 'Error: Package: hadoop_3_2_0_0_108-hdfs-3.1.1-1.el7.centos.x86_64 (JDP-3.2-repo-3)
           Requires: libtirpc-devel
```

原因：制作的本地源缺少 libtirpc-devel rpm 包

执行 `yum search libtirpc-devel `命令查找本地源中是否有这个包，没有说明本地 OS 源制作有问题。

注意：离线源安装JDP时，需要制作JDP的离线源和OS离线源，JDP中的部分组件依赖于 OS 源中的一些RPM包。


