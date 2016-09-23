###关于UIViewPropertyAnimator的学习总结：
####1. 系统的贝塞尔曲线
init(duration: TimeInterval, curve: UIViewAnimationCurve, animations: () -> Void)? = nil)<br>
`duration`:动画持续时间<br>
`curve`:这个属性决定动画执行过程中随着时间的推移，进度执行的快慢（枚举）<br>
case easeInOut -> 开始和结尾慢，中间快<br> 
case easeIn -> 开始慢 <br>
case easeOut -> 结尾慢 <br>
case linear -> 匀速 <br>
如下图所示：![image](https://github.com/wangCanHui/UIViewPropertyAnimatorDemo/blob/master/四种类型的贝塞尔曲线图.png)
####2. 自定义三次方贝塞尔曲线（两种实现方法）
#####2.1 直接用构造函数创建
init(duration: TimeInterval, controlPoint1: CGPoint, controlPoint2: CGPoint, animations: () -> Void)? = nil)<br>
`duration`:动画持续时间<br>
`controlPoint1`:贝塞尔曲线的第一个控制点，取值范围0~1.0<br>
`controlPoint2`:贝塞尔曲线的第二个控制点，取值范围0~1.0<br>
如下图所示：<br>![image](https://github.com/wangCanHui/UIViewPropertyAnimatorDemo/blob/master/手动绘制的贝塞尔图形.png)<br>
以上截图都来自这个[点我哦😯](http://cubic-bezier.com/#.1,.79,.23,.88)在线绘制贝塞尔曲线的工具，大家有必要亲自体验一下绘制贝塞尔曲线，就很容易理解控制点的作用了。
#####2.2 通过UICubicTimingParameters实例化对象来创建
let bezierParams = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.2, y: 0.8), controlPoint2: CGPoint(x: 0.2, y: 0.8))<br>
UIViewPropertyAnimator(duration: 3, timingParameters: bezierParams)<br>
`controlPoint1`:贝塞尔曲线的第一个控制点，取值范围0~1.0<br>
`controlPoint2`:贝塞尔曲线的第二个控制点，取值范围0~1.0<br>
####3. 系统的阻尼振动
init(duration: TimeInterval, dampingRatio ratio: CGFloat, animations: (@escaping () -> Swift.Void)? = nil)
`duration`:动画持续时间（值过大就没什么效果和意义了）<br>
`dampingRatio`:阻尼系数 1.欠阻尼（取值范围0~1.0 ，值越小振动效果越明显） 2.临界阻尼 取值为1  3.过阻尼（取值范围>1 ，值越大振动越不明显）<br>
####4. 自定义阻尼振动，以及暂停、继续、反向、取消等动画效果的Demo
#####4.1 使用UISpringTimingParameters的构造方法自定义阻尼振动
let springParameters = UISpringTimingParameters(mass: 3, stiffness: 20, damping: 1, initialVelocity: velocity)<br>
UIViewPropertyAnimator(duration: 1, timingParameters: springParameters)<br>
`duration`:动画持续时间（这个方法中，个人感觉不到这个值对动画效果的影响）<br>
`mass`:质量参数<br>
`stiffness`:劲度系数（弹性系数） 描述单位形变量时所产生弹力的大小，F = K * △X (F为弹力，K是劲度系数，△x是弹簧形变量)<br>
`damping`:阻尼系数 1.欠阻尼（取值范围0~1.0 ，值越小振动效果越明显） 2.临界阻尼 取值为1  3.过阻尼（取值范围>1 ，值越大振动越不明显）<br>
`initialVelocity`:初始速度（矢量，值越大速度越快）<br>
决定动画效果的主要是mass、stiffness、damping、initialVelocity这四个参数，劲度系数（stiffness）越大，质量参数（mass）值也不能过小，阻尼系数（damping）越小，初始速度（initialVelocity）越大，振动效果越明显，而且持续时间越久，反之振动效果越微弱，动画持续时间越短。<br>
为了帮助理解上面的话，截了阻尼振动的图如下所示：<br>
![image](https://github.com/wangCanHui/UIViewPropertyAnimatorDemo/blob/master/%E9%98%BB%E5%B0%BC%E6%8C%AF%E5%8A%A8.png)
#####4.2 暂停动画
pauseAnimation
#####4.3 继续动画（两种方法）
（1） startAnimation：只能使未完成的动画，继续执行到结束。<br>
（2） continueAnimation：不仅可以是未完成的动画继续执行到结束，还可以重新制定未完成动画的效果。<br>
continueAnimation(withTimingParameters: nil, durationFactor: animator.fractionComplete)，显然看到使用continueAnimation，还可以改变未完成的动画效果，只需给withTimingParameters参数赋值即可。
#####4.4 动画反向
isReversed = true, 即可使动画反向执行
#####4.5 结束动画
stopAnimation
####5. 动画三种状态的转换（inactive、active、stopped）
如下图所示：<br>
![image](https://github.com/wangCanHui/UIViewPropertyAnimatorDemo/blob/master/%E5%8A%A8%E7%94%BB%E7%8A%B6%E6%80%81.png)<br>
可以看出stopped状态只是中间的一个过渡状态，实际代码中不能使用这种状态判断动画的当前状态，只能用inactive（休眠）或者active(激活)来判断，有趣的是pause可以使已经初始化的animator的状态由Inactive变为active，但是动画还是暂停状态，需要调用继续动画的方法才能使动画执行。
