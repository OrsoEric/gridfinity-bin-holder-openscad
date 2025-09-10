# Gridfinity Bin and Holder OpenSCAD

The scope of this project is to design a stackable gridfinity bin and its holder

## History

Inspiration comes from this design that is very heavy
Design light bins and holders using the gridfinity standard

![](/images/Gridfinity%20Holder.jpg)

[Thingieverse](https://www.printables.com/model/561688-lite-base-for-gridfinity-storage-box-by-pred-now-p/files)

## Improvements

OpenSCAD design

An holder that stacks vertically, so bottom of the holder acts as lid for the holder above.

Snap hinges that are much easier to open

Smaller profile to allow 4x5 printing on a K1 220x220 bed


# Design

## Gridfinity Spec

[Gridfinity Spec](https://gridfinity.xyz/specification/)

![](/images/Gridfinity%20Spec%20willtree8.jpg)

I used a scad gridfinity library for the profile, I found out it's not exactly compliant with Gridfinity spec, one day I'd like to redo it.

## Hinge

The hinge was a sticky part of the design.

I decided to do it vertically, to do a teardrop shape to help with printing, to use the spring action on the side members. It turned out really well and does a satisfying click.

![](/images/Hinge%20Creality.png)

![](/images/Hinge%20Printed.jpg)

It has a weak point on the side, a future improvement would be tu bury the hinge inside the wall.

## Light Wall

I decided to drill the walls to remove material. After some consideration, I decided for rombus smooth holes in a diagonal grid pattern.

Consideration is to make the rombus taller than they are wide in order to help with overhangs.

![](/images/Rounded%20Diamond%20Sliced%20In%20Z.png)

I asked some help on [stack overflow](https://stackoverflow.com/questions/79713218/openscad-concavehull) how to render the smooth rombus because it's concave and doesn't work with hull.

With the diamonds made, I designed the diamond grid pattern.

![](/images/Diamond%20Grid%20Pattern.png)

From there it's just a matter of extruding that from a regular wall to get a really nice pattern to save on material.

![](/images/2025-09-10-T1328%20Light%20Wall.png)

TODO: I can only handle odd rows because I couldn't be bothered to make the even cutout. In the future I should add the logic to do that, it would make more flexible and scalable the pattern.

## Bin

Making a stackable bin is fairly easy.

It combines a butt, lips for the top, and light walls, all with the proper logic to extend in X and Y direction and get all the roundings and margin right.

![](/images/2025-07-27-T1245%20Bin%202%20by%203.png)

I use parameters to decide the number of holes based on bin size and it works fairly well, it's a really nice looking bin with a nice primitive.

## Holder

Making the holder took a lot of effort.

Using the bottom to serve as lid, required working a lot on the geometry to get everything right while keeping everything parametric.

Placing the hinges so that it would close and have good tollerance.

The result is great!

![](/images/2025-07-31%20Holder%201%20by%201.png)

The black was the first attempt, later I did the white with more spaced holes, tougher hinges and looser tollerance. I ended up doing hinges on just one side since it was good enough and it has great self alignmet.

![](/images/one%20by%20one.jpg)

![](/images/one%20by%20one%20stacked.jpg)

It works great on larger sizes

![](/images/2025-08-16-T1150%20Gridfinity%204x5%20Die%20Holder.jpg)

It stacks properly and allow me to carry items

## Lid

The lid is an holder with lots of pieces removed.

![](/images/2025-09-10-T1355%20Lid%204x5.png)

## Handles

I haven't figured out a good way to do handles.

The get to big if I do it in one piece.

I think in the future I'll do an insert to let a handle be screwed in, and make it more convenient to unstuck the holders.