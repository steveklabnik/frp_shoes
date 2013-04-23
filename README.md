FRP Shoes
=========

Functional reactive programming with Shoooooooes.

Reference Implementation
------------------------

`reference.rb` contains a simple Shoes app, written in the usual Shoes style.
Basically, there are two buttons, +1 and -1, and a `para` with a count. It
starts at zero, and the buttons increment and decrement the count.

FRP Implementation
------------------
`frp.rb` contains the same app, but written in an FRP style with [frappuccino](https://github.com/steveklabnik/frappuccino).

What's different?
-----------------

Here's the diff:

```diff
--- reference.rb	2013-04-23 12:05:50.000000000 +0200
+++ frp.rb	2013-04-23 15:01:17.000000000 +0200
@@ -1,19 +1,40 @@
+require 'frappuccino'
+
+class Button
+  def initialize(event)
+    @event = event
+  end
+
+  def push
+    emit(@event)
+  end
+end
+
 Shoes.app :height => 150, :width => 250 do
   background rgb(240, 250, 208)

+  @plus = Button.new(:+)
+  @minus = Button.new(:-)
+
+  @stream = Frappuccino::Stream.new(@plus, @minus)
+
+  @counter = @stream
+              .map_stream(:+ => 1, :- => -1, :default => 0)
+              .inject(0) {|sum, n| sum + n }
+
   stack :margin => 10 do
     button "+1" do
-      @count += 1
-      @label.replace "Current count: #@count"
+      @plus.push
     end

     button "-1" do
-      @count -= 1
-      @label.replace "Current count: #@count"
+      @minus.push
     end

-    @count = 0
+    @label = para "Current count: #{@counter.to_i}"

-    @label = para "Current count: #@count"
+    @counter.on_value do |value|
+      @label.replace "Current count: #{value}"
+    end
   end
 end
```

Let's go over the differences:

The old buttons used to handle both incrementing the count, as well as
replacing the label. Now, the buttons do one thing: call a method on their
`Button` reference. The streams handle responding to the press and doing
the update.

We have that `Button` classes. This is largely because of the way that
Shoes works; I _think_ I could get away from this, but in larger GUI apps
you'll have pure Ruby models anyway; putting logic into the UI stuff is
a general antipattern. It's nice for small things, which is one of the things
Shoes is great at, but bigger apps (like Hackety) get out of control really
quickly.

Constructing the count is no longer spit between the two buttons, it's in the
`#inject` call. This is a win: it went from being spread out among two places
to being in just one place.

The update is now handled in one place as well: the `#on_value` callback we've
added to the stream. Same deal: this was in two places, now it's in one.

That's really it. Neat.

Running this yourself
---------------------

Okay, so I really wanted to make this mega-easy, so I included a
Gemfile... the issue is that Shoes 4 is still in flux, and so it
doesn't include binaries in the gem. Nuts. So, you'll have to
clone down Shoes, and then run it from there. 

Don't forget: Shoes 4 is based on JRuby, so you have to be
using that.

Anyway, here's what you have to do:

```bash
$ git clone https://github.com/shoes/shoes4.git
$ git clone https://github.com/steveklabnik/frappuccino.git
$ git clone https://github.com/steveklabnik/frp_shoes.git
$ cd frappuccino
$ bundle
$ rake install
$ cd ../shoes4
$ bundle
$ bin/swt-shoooes ../frp_shoes/frp.rb
```
