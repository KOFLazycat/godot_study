# Godot初始化项目结构

```
res://
└───addons                                      插件
└───docs                                        文档
└───src                                         源码
│   └───main                                    主代码
|   |   └───assets                              资源文件
|   |   |   └───shaders                         着色器
|   |   |   └───sound                           声音
|   |   |   └───texture                         图片
|   |   |   |   └───icon                        
|   |   |   |   └───role
|   |   |   |   |   └───enemy
|   |   |   |   |   └───player
|   |   |   |   └───vfx
|   |   └───common                              通用文件
|   |   |   └───autoload                        自动加载、单例
|   |   |   └───util                            工具类
|   |   └───component                           可复用组件
|   |   └───scene                               场景
|   |   |   └───level                           关卡
|   |   |   └───role                            游戏中的各种角色
|   |   |   |   └───building                    建筑
|   |   |   |   └───bullet                      子弹
|   |   |   |   └───enemy                       敌人
|   |   |   |   |   └───goblin
|   |   |   |   |   └───shrem
|   |   |   |   └───player                      玩家控制角色
|   |   |   |   └───shop                        商店
|   |   |   └───ui                              自动加载、单例
│   └───test                                    
|...
|

```