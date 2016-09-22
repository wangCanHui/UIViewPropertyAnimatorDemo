###关于UIViewPropertyAnimator的学习总结：
####1. 系统的贝塞尔曲线
init(duration: TimeInterval, curve: UIViewAnimationCurve, animations: () -> Void)? = nil)<br>
`duration`:动画持续时间<br>
`curve`:这个属性决定动画执行过程中随着时间的推移，进度执行的快慢<br>
case easeInOut -> 开始和结尾慢，中间快<br> 
case easeIn -> 开始慢 <br>
case easeOut -> 结尾慢 <br>
case linear -> 匀速 <br>
如下图所示：![image](https://github.com/wangCanHui/UIViewPropertyAnimatorDemo/blob/master/四种类型的贝塞尔曲线图.png)
####2. 自定义三次方贝塞尔曲线（两种实现方法）
init(duration: TimeInterval, controlPoint1: CGPoint, controlPoint2: CGPoint, animations: () -> Void)? = nil)
`duration`:动画持续时间<br>
`controlPoint1`:贝塞尔曲线的第一个控制点，取值范围0~1.0<br>
`controlPoint2`:贝塞尔曲线的第二个控制点，取值范围0~1.0<br>
如下图所示：<br>![image](https://github.com/wangCanHui/UIViewPropertyAnimatorDemo/blob/master/手动绘制的贝塞尔图形.png)<br>
以上截图都来自这个[点我哦😯](http://cubic-bezier.com/#.1,.79,.23,.88)在线绘制贝塞尔曲线的工具，大家有必要亲自体验一下绘制贝塞尔曲线，就很容易理解控制点的作用了。
####3. 系统的阻尼振动
####4. 自定义阻尼振动，以及暂停、继续、反向、取消等动画效果的Demo


