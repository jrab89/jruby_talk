layout: true
class: middle, center

---

background-image: url(jruby-logo-logo-with-type-xlarge.png)

???
Hi! I'm Jeff
I'm a senior engineer at a company called Centro.
We make software tools for advertisers.
We're also just 1 block south of here so that walking over easy.
I'm on team that writes Python code to automate the operators of our Ruby on Rails application.
So you might wonder why I, as a person who does Ruby, Python, and Operations, am speaking at a Java Meetup?
Don't Ruby people have their own Meetups they go to?
We do, and I go to those too, but I'm also here to introduce you to an awesome project called JRuby.

---

# Ruby? What?! Why?!?

???
So why is JRuby awesome?
To answer that, first it would help to know more about Ruby.
Ruby is a dynamically typed, interpreted, object oriented programming language.

--

![Matz](matz copy.jpg)

Yukihiro "Matz" Matsumoto

???
It was originially designed and developed by this guy in Japan in the mid 90s:
Yukihiro Matsumoto, but the people in the Ruby community refer to him as "Matz".
Interestingly, both Ruby and Java had their 1.0 releases in 1996.

---

# People still use Ruby?

???
You might be wondering...people still use Ruby?
Yes they do! And not just at startups.
Here's some open source Ruby projects that you may have heard of or used.

--

.jv[
  ![rails](rails_logo.png)
  ![vagrant](vagrant_logo.png)
  ![metasploit](Metasploit_logo.png)
]

.jv[
  ![homebrew](Homebrew_logo.png)
  ![chef](Chef_logo.png)
]

???
Rails is a big one. It's really the project that got people outside of Japan excited about Ruby.
It's a fullstack web framework.
It was extracted from Basecamp, the project management software made by 37signals.
They're actually a Chicago based company.
Rails was open sourced in 2004, and has gotten really popular since then.

---

.jv[
  ![github](github_logo.png)
  ![shopify](shopify.png)
  ![airbnb](Airbnb_Logo.png)
]

.jv[
  ![soundcloud](soundcloud.png)
  ![zendesk](zendesk.jpg)
  ![groupon](groupon.png)
]

???
And if you're curious here's some companies that are worth billions of dollars that use Rails!

---

```java
public class Circle {
  private final int radius;

  public Circle(int radius){
    this.radius = radius;
  }

  public int getRadius(){
    return this.radius;
  }

  public double getArea(){
    return Math.PI * Math.pow(radius, 2);
  }

  public static void main(String[] args){
    int radius = Integer.parseInt(args[0]);
    Circle circle = new Circle(radius);
    System.out.println(circle.getArea());
  }
}
```

???
Hopefully I've got you excited about Ruby.
How about some code?
Here's some Java, and I'll show you the equivalent Ruby code in a minute.
We've got a command line program that takes an integer,
and computes the area of a circle with that radius.

---

```sh
$ javac Circle.java
$ java Circle 2
12.566370614359172
```

???
And here's how you'd run that.
I'm using this amazing build tool called 'javac'
But you could use a build tool like Maven or Gradle if you want.

---

```rb
class Circle
  attr_reader :radius
  def initialize(radius)
    @radius = radius
  end

  def area
    Math::PI * radius**2
  end
end

radius = ARGV[0].to_i
puts Circle.new(radius).area
```

```sh
$ ruby circle.rb 2
12.566370614359172
```

???
And here's the Ruby version.
At first glance it's a lot more concise.
And concise is great!
The less code we have to write to accomplish the same thing means we're more productive.
And less code we have, the less bugs we have!
The first difference is that in Ruby constructors are always called initialize.
In our constructor we're assigning to the radius instance variable.
Instance variables are denoted with an 'at' sign.
There's also this 'attr_reader' above the constructor.
'attr_reader' is actually a method call, and it takes the symbol 'radius' as an argument.
In Ruby method calls don't require parens, which is why there aren't any here.
A symbol is an immutable string, they always start with a colon, and they're used as keys to hashes or as the possible values of an enum type.
It's the same thing as a keyword in Clojure, if you're familiar with that.
This method isn't called on a circle instance, but on the circle class itself.
In Ruby everything is an object, including classes and primative types, and every operation is a method call.
This method adds a getter methd for the radius instance variable at runtime.
Then we have the 'area' method.
The last value computed in a method is implicity returned.
This means we don't need a 'return' there, and that there are no void methods in Ruby.
And down here we're instantiating a circle and calling the area method on it.
There is no 'new' keyword, 'new' is just a method call on a class.
And for the call to the area method, it's idiomatic in Ruby to not use parens when calling a method that takes no arguments.
And the 'puts' method prints a string to stdout, which omitting parens when we call that.

---

![duck_typing](duck_typing.png)

???
There's also aren't type declarations in Ruby code.
We don't really care about what concrete type something is in Ruby.
We just care about the methods an object respond to.
This is called Duck typing.
If something has a quack method, then it may as well be a duck.
It's kind of like an interface that isn't statically checked.
And it's true that without static checking you can have runtime errors.
This can be a little scary, but it's really not any more scary that typecasting in Java.
In most cases you catch this sort of thing with automated testing, we all write tests right?
So in real Ruby code lack of static type checking doesn't cause problems,
and isn't any more scary than a ClassCastException or a NullPointerException,
and we've all seen those.

---

background-image: url(ruby_concurrency.jpg)

???
The Ruby that most people use is written in C, and is often referred to as C Ruby.
People also call it MRI, short for "Matz's Ruby Interpreter".
JRuby is a Ruby implementation that's written in pure Java; it's Ruby on the JVM.
If you're sold on the whole Ruby thing, why bother with JRuby or the JVM at all though?
Well, as much as I like Ruby is does have some short-commings.
The concurrency story is not very good.
Similar to Python, C Ruby has a global interpreter lock, or GIL for short.
This means that while you can write multithreaded Ruby code, you can't actually do parallel computation in the same Ruby process.
In more recent versions of Ruby, you can have parellel I/O and native code extensions running in the same Ruby process.
This is helpful for doing things like making HTTP requests or parsing JSON, but it's still not ideal.
JRuby has no such limitations. You get Java threads and Java GC. Both of which are amazing.
And your Ruby code gets just in time complied.

---

```rb
require 'prime'
require 'concurrent'

max = ARGV[0].to_i
thread_count = ARGV[1].to_i

pool = Concurrent::FixedThreadPool.new(thread_count)
2.upto(max) do
  pool.post do
    Prime.prime_division(max)
  end
end

pool.shutdown
pool.wait_for_termination
```

???
To show off what you can do with JRuby's concurrency,
here's a command line program that computes the prime factors of integers up to some number.
It's using a fixed size thread pool, where the number of threads is parametized.
And it just hands the pool all the work and waits for it to finish.

---

```sh
$ time ruby prime_factors.rb 10000000 1
ruby prime_factors.rb 10000000 1  91.33s user 2.37s system 99% cpu 1:33.80 total
$ time ruby prime_factors.rb 10000000 16
ruby prime_factors.rb 10000000 16  76.71s user 0.97s system 99% cpu 1:17.77 total
$ time jruby prime_factors.rb 10000000 1
jruby prime_factors.rb 10000000 1  373.74s user 4.41s system 444% cpu 1:25.01 total
$ time jruby prime_factors.rb 10000000 16
jruby prime_factors.rb 10000000 16  125.74s user 17.97s system 449% cpu 31.976 total
```

???
Computing the prime factors of integers up to ten million in C Ruby with a single thread takes about 1.5 minutes.
With 16 threads it doesn't get any better.
And with JRuby using a single thread performance is about the same.
With JRuby and 16 threads we see a substantial speedup.

---

# There's more!

https://jrab89.github.io/

???
JRuby also has great interop with JVM languages.
So can call Java from your Ruby and Ruby from your Java!
That's probably too much detail for today,
but here's a link to my blog where I show how that works by
driving JDBC from Ruby! Thanks!