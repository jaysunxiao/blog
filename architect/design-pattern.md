# 一、设计模式六大原则
- 1.单一职责原则
```
一个类只负责一项职责。 
```

- 2.里氏替换原则
```
所有引用父类的地方必须能透明地使用其子类的对象。

继承作为面向对象三大特性之一，在给程序设计带来巨大便利的同时，也带来了弊端。
比如使用继承会给程序带来侵入性，程序的可移植性降低，增加了对象间的耦合性，
如果一个类被其他的类所继承，则当这个类需要修改时，必须考虑到所有的子类，并且父类修改后，所有涉及到子类的功能都有可能会产生故障。

里氏替换原则通俗的来讲就是：子类可以扩展父类的功能，但不能改变父类原有的功能。它包含以下4层含义：
子类可以实现父类的抽象方法，但不能覆盖父类的非抽象方法。
子类中可以增加自己特有的方法。
```

- 3.依赖倒置原则
```
高层模块不应该依赖低层模块，二者都应该依赖其抽象；抽象不应该依赖细节；细节应该依赖抽象。
依赖倒置原则的核心就是要我们面向接口编程，理解了面向接口编程，也就理解了依赖倒置。
```

- 4.接口隔离原则
```
一个类对另一个类的依赖应该建立在最小的接口上。 
接口隔离原则的含义是：建立单一接口，不要建立庞大臃肿的接口，尽量细化接口，接口中的方法尽量少。
```

- 5.迪米特法则
```
迪米特法则又叫最少知道原则，一个对象应该对其他对象保持最少的了解。
```

- 6.开闭原则
```
一个软件实体如类、模块和函数应该对扩展开放，对修改关闭。
```

# 二、23种设计模式

## 1.创建型模式
1. 简单工厂：一个工厂类根据传入的参量决定创建出那一种产品类的实例。
2. 工厂方法：定义一个创建对象的接口，让子类决定实例化那个类。
3. 抽象工厂：创建相关或依赖对象的家族，而无需明确指定具体类。
4. 建造者模式：封装一个复杂对象的构建过程，并可以按步骤构造。如StringBuilder的append()
5. 单例模式：饿汉式，懒汉式，双重检测，静态内部类，枚举类实现具有天然的线程安全并且避免反射和反序列化漏洞
6. 原型模式：prototype，通过复制现有的实例来创建新的实例。如深克隆，浅克隆


## 2.结构型模式
1. 适配器模式：将一个类的方法接口转换成客户希望的另外一个接口。如各种Adapter
2. 组合模式：将对象组合成树形结构以表示的层次结构。可以理解成组合，如窗体控件，一个下滑的窗口中包含的List
3. 装饰模式：动态的给对象添加新的功能。如Java的IO流
4. 代理模式：为其他对象提供一个代理以便控制这个对象的访问。如静态代理，动态代理javaassist
5. 亨元模式：通过共享技术来有效的支持大量细粒度的对象。
6. 外观模式：facade，对外提供一个统一的方法，来访问子系统中的一群接口。
7. 桥接模式：将抽象部分和它的实现部分分离，取代多层继承，多层继承违反单一职责。如DriverManager -- JDBC驱动 -- (MySQL Oracle)


## 3.行为型模式
1. 模板模式：定义一个算法结构，而将一些步骤延迟到子类实现。
2. 解释器模式：给定一个语言，定义它的文法的一种表示，并定义一个解释器。如Spring的expression
3. 策略模式：定义一系列算法，把他们封装起来，并且使它们可以相互替换。
4. 状态模式：允许一个对象在其对象内部状态改变时改变它的行为。
5. 观察者模式：对象间的一对多的依赖关系。
6. 备忘录模式：在不破坏封装的前提下，保持对象的内部状态，以便提供一个可回滚的操作。
7. 中介者模式：用一个中介对象来封装一系列的对象交互。如java反射method.invoke()
8. 命令模式：将命令请求封装为一个对象，使得可以用不同的请求来进行参数化。如执行sql语句
9. 访问者模式：对于存储再一个集合中的对象，它们可能具有不同的类型，不同的访问者，其访问方式不同。
10. 责任链模式：将请求的发送者和接收者解耦，使的多个对象都有处理这个请求的机会。
11. 迭代器模式：一种遍历访问聚合对象中各个元素的方法，不暴露该对象的内部结构。如Iterator接口

# 三、难点解析
## 1.访问者模式
```
abstract class Student {
　　 //提供对于数据域基本操作的函数
    private String name;
    private String university;
    private String rating;
    //让指定的visitor获得操作该对象的权限
    public abstract void accept(Visitor visitor);
}

class Bachelor extends Student{
    @Override
    public void accept( Visitor visitor ) {
        visitor.visit( this );
    }
}

class College extends Student{
    @Override
    public void accept(Visitor visitor) {
        visitor.visit(this);
    }
}

因为我们只定义了两种学生,所以接口提供了对于两种Element访问
interface Visitor{
    public void visit ( Bachelor bachelor );
    public void visit ( College college );
}

首先筛选简历我们看一下大家的简历都什么样子，那么需要一个ShowVisitor:
class ShowVisitor implements Visitor {
    @Override
    public void visit(Bachelor bachelor) {
        System.out.println("a bachelor");
        this.printMessage( bachelor );
    }

    @Override
    public void visit(College college) {
        System.out.println("a college student!");
        this.printMessage( college );
    }

    public void printMessage ( Student student ){
        System.out.println( "Name : " + student.getName()+"\n"
                + "University : " + student.getUniversity()+"\n"
                + "Rating : " + student.getRating() + "\n"
        );
    }
}

测试：
public class VisitorEg {
    public static void main ( String [] args ){
        ArrayList<Student> list = new ArrayList<Student>();
        Bachelor bachelor = new Bachelor();
        bachelor.setName("llin");
        bachelor.setRating("100");
        bachelor.setUniversity("Tianjin University");

        College college = new College();
        college.setUniversity("Tianjin college");
        college.setRating("1");
        college.setName("dalinge");

        list.add ( bachelor );
        list.add ( college );

        Visitor visitor = new ShowVisitor();
        for ( Student student: list ){
            student.accept( visitor );
        }

    }
}


那么好像看不出访问者模式有什么优势，而且费事，但是因为你将数据结构和对数据的操作分离了(解耦),
所以当我想添加新的操作时，不需要修改原有的类，只需要重新实现一个visitor就可以了。
所以，我们回到这个例子，这么多人报名，那么到底有多少本科生呢？

class SumVisitor implements Visitor{

    private int totalBachelor;

    @Override
    public void visit(Bachelor bachelor) {
        totalBachelor++;
    }

    @Override
    public void visit(College college) {
    }

    public int getTotal_bachelor() {
        return totalBachelor;
    }
}

public class VisitorEg {
    public static void main ( String [] args ){
        ArrayList<Student> list = new ArrayList<Student>();
        Bachelor bachelor = new Bachelor();
        bachelor.setName("llin");
        bachelor.setRating("100");
        bachelor.setUniversity("Tianjin University");

        College college = new College();
        college.setUniversity("Tianjin college");
        college.setRating("1");
        college.setName("dalinge");

        list.add ( bachelor );
        list.add ( college );

        Visitor visitor = new ShowVisitor();
        Visitor visitor1 = new SumVisitor();
        for ( Student student: list ){
            student.accept( visitor );
            student.accept( visitor1);
        }
        System.out.println( "The total sum of bachelors : "+ ((SumVisitor)visitor1).getTotal_bachelor() );
    }
}

达到了要求，却没有修改一行代码
```
