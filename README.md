
# ChatServer


工作在nginx tcp负载均衡的集群聊天服务器和客户端 基于muduo实现 数据库mysql 消息队列redis

构建命令
  `./build.sh`

## 技术栈



- Json序列化和反序列化
- muduo网络库开发
- nginx的tcp负载均衡器配置
- 基于发布-订阅的服务器中间件redis消息队列
- MySQL数据库编程

- CMake构建编译环境



## 项目需求



1. 客户端新用户注册

2. 客户端用户登录

3. 添加好友和添加群组
4. 好友聊天
5. 群组聊天
6. 离线消息
7. nginx配置tcp负载均衡
8. 集群聊天系统支持客户端跨服务器通信



## 项目目标



1. 掌握服务器的网络I/O模块，业务模块，数据模块分层的设计思想
2. 掌握C++ muduo网络库的编程以及实现原理
3. 掌握Json的编程应用
4. 掌握nginx配置部署tcp负载均衡器的应用以及原理
5. 掌握服务器中间件的应用场景和基于发布-订阅的redis编程实践以及应用原理
6. 掌握CMake构建自动化编译环境
7. 掌握Github管理项目





## 数据库设计



### User表

| 字段名称 | 字段类型                   | 字段说明     | 约束                          |
| -------- | -------------------------- | ------------ | ----------------------------- |
| id       | INT                        | 用户id       | PRIMARY KEY, AUTO_INCRECEMENT |
| name     | VARCHAR(50)                | 用户名       | NOT NULL, UNIQUE              |
| password | VARCHAR(50)                | 用户密码     | NOT NULL                      |
| state    | ENUM('online',  'offline') | 当前登陆状态 | DEFAULT 'offline'             |



### Friend表

| 字段名称 | 字段类型 | 字段说明 | 约束               |
| -------- | -------- | -------- | ------------------ |
| userid   | INT      | 用户id   | NOT NULL, 联合主键 |
| friendid | INT      | 好友id   | NOT NULL, 联合主键 |



### AllGroup表

| 字段名称  | 字段类型     | 字段说明   | 约束                          |
| --------- | ------------ | ---------- | ----------------------------- |
| id        | INT          | 组id       | PRIMARY KEY, AUTO_INCRECEMENT |
| groupname | VARCHAR(50)  | 组名称     | NOT NULL, UNIQUE              |
| groupdesc | VARCHAR(200) | 组功能描述 | DEFAULT ' '                   |



### GroupUser表



| 字段名称  | 字段类型                  | 字段说明 | 约束               |
| --------- | ------------------------- | -------- | ------------------ |
| groupid   | INT                       | 组id     | NOT NULL, 联合主键 |
| userid    | INT                       | 组员id   | NOT NULL, 联合主键 |
| grouprole | ENUM('creator', 'normal') | 组内角色 | DEFAULT 'normal'   |



### OfflineMessage表

| 字段名称 | 字段类型     | 字段说明                   | 约束     |
| -------- | ------------ | -------------------------- | -------- |
| userid   | INT          | 用户id                     | NOT NULL |
| message  | VARCHAR(500) | 离线消息（存储Json字符串） | NOT NULL |





## 项目开发过程



- 网络模块ChatServer

由TcpServer和EventLoop组成，功能是通过注册回调机制实现服务器响应连接，读写事件。处理读写事件的回调函数，对json反序列化，获取msgid的值，调用ChatService的getHandler函数获取事件处理函数。



- 业务模块ChatService

由处理登录，处理注册，一对一聊天，添加好友，创建群组，加入群组，群组聊天，处理注销，处理客户端异常退出，服务器异常业务重置组成。



- 数据库db层

封装数据库初始化连接，释放连接，连接数据库，更新操作，查询操作。



- Model层

frendmodel：维护好友信息的操作接口

group：群组表

groupModel：群组表操作

groupUser：群组操作

OfflineMsgModel：离线消息表

user：User表

userModel：User表的操作



- redis层

实现发布订阅消息队列

