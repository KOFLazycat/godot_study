extends Node
class_name State ######## 状态基类

## 状态切换信号
signal update_state(state_name: String)

## 状态进入
func enter() -> void: pass

## 帧更新
func update(_delta: float) -> void: pass

## 物理帧更新
func physics_update(_delta: float) -> void: pass 

## 状态退出
func exit() -> void: pass


