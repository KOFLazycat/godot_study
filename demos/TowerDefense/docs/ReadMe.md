# 项目结构

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

# 项目说明

## 一个简单的塔防游戏，核心玩法就是放置防御塔，阻止怪物前进。
## 玩法特色：1. 包含肉鸽元素，每次放置塔是由击杀怪物金币自动触发的3选一，不能自主决定放什么塔，或者升级，后续会支持元素、天气、日夜、塔塔联动、颜色互动、战棋玩法等；
## 2. 塔也会有生命，怪物可以对塔造成伤害
## 3. 其他待定