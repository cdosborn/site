<!--
Scope creep!!!
Thesis:
Applicative functors allow you to apply arguments to functions despite those
arguments being in strange contexts.
-->
In this post, I discuss the Applicative functor and how, like every functor,
it works to make functions more useful.

```
f a b c
```

```
pure f <$> a <$> b <$> c <$> d
```

## What is a functor?
## What is Applicative for?
In Haskell there are only functions of a single input and a single output.
When you pass only a single argument to a function, you get back a function
which accepts the next argument, and so on for each argument.

By calling `+` with one number, the result is a function which
takes the remaining argument.
```
> let addThree = (+ 3)
> addThree 1
4
```
This makes functions more useful, as if they exist simultaneously in forms
that accept fewer arguments.

`addThree` operates specifically on numbers, but I can use `fmap` to apply
this function to more complex objects.
```
> fmap addThree (Just 1)
Just 4
```

In the first case, the value `1` is in a `Maybe` context. In that
context, values may or may not exist. `Maybe` is an instance of the `Functor`
typeclass; it defines `fmap` which applies a function (`addThree`) to the
value inside the context (`1`). Note that we didn't have to define a separate
`addThree` that takes `Maybe` numbers as arguments. In Haskell, there are
numerous contexts and that would be a lot of repetition!

We can also use `fmap` with functions that have more than one argument.

```
> let maybeAddThree = fmap (+) (Just 3)
Just <function> -- Equivalent to Just (+ 3)
```

Notice that we now have a function in a context. `fmap` takes a function
**without** a context and applies it to arguments **with** a context. `apply` is
the version of `fmap` for functions already in a context.
```
> maybeAddThree <*> (Just 1)
Just 4
> fmap (\x y z -> x+y+z) (Just 1) <*> (Just 1) <*> (Just 1)
Just 3
```

`fmap` and `apply` take existing functions and make them useful in whatever
context they are needed.

## Writing a generic version of `apply`

In order to create an instance of `Applicative`, you must define `pure` and "apply"
denoted by `<*>`.

I was wondering why each instance of Applicative must define `apply`. The type
signature for apply is nearly identical to `fmap`.
```
fmap :: Functor f => (a -> b) -> f a -> f b
(<*>) :: Applicative f => f (a -> b) -> f a -> f b
```

I started working out a solution, and came up with something more complex than
I hoped. I'll walk through the defintion and explain why each constraint on
the arguments is necessary.

```
(<*>)
    :: (Functor f, Foldable f, Monoid (f a), Monoid (f b))
    => f (a -> b)
    -> f a
    -> f b
(<*>) ff fa = foldMap (\f -> fmap f fa) ff
```

`foldMap` requires a function to translate each element of a parcel into a
Monoid. Equipped with the contents of a parcel as a collecton of monoids,
`foldMap` can `mappend` them all into a single Monoid. Roughly speaking,
`foldMap` says, "Show me how to translate the contents of your parcel into
bits that I can join together and I will join them together".

When I began working on this definition. I didn't know about `foldMap` and I didn't know bout

1. Each `a -> b` parcel, contains zero or more `a -> b`s. We can use a particular `a -> b` and a parcel of `a` to generate a parcel of `b`.
2. Since `f (a -> b)` is a parcel of `a -> b`s, we will have to use principle 1 for each "a -> b". When we do that, we'll end up with parcels of b for each corresponding parcel of `a -> b`.
3. Since our signature yields a single `f b`, we will need some way of joining these parcels of b. Since this parcel is a Monoid, we can join many into one.

<!--
<div class="footnotes">
<p>
    <a id="fn:1:defn">1.</a>
    This is only possible, because these objects have defined what it means for
    them to be mapped over.
    <a href="#fn:1">↩</a>
</p>
</div>
-->
<!--
- how apply must work for any particular instance and why a defintion can be
written in terms of behavior of other type classes

In order to simplify our terminology, we can describe this signature using [parcels](https://blog.plover.com/prog/haskell/parcel.html).
> A parcel of type _a_, is a value of type _f a_ where _f_ is an arbitrary
functor. A parcel is box of _a_'s.

Apply takes a parcel of `a -> b`, a parcel of `a`, and returns a parcel of `b`. The parcel could be a `Maybe`, a `[]`, or any other functor.


Here are some examples with `Maybe`.
```
> Just (+ 1) <*> (Just 1)
Just 2
> Nothing <*> (Just 1)
Nothing
> Just (+ 1) <*> Nothing
Nothing
```

Here are some example with `[]`.
```
> [(+1)] <*> [1,2,3]
[2,3,4]
> [id, negate] <*> [1,2,3]
[1,2,3,-1,-2,-3]
```
The second example may be a bit unexpected, because the list monad represents something different than traditional lists in other languages. Here it represents a value which is many values—at the same time.

So when we apply a list of functions to a list of numbers, it's as if we're
applying a single function (simultaneously that is two functions) to a single
value (simultateously that is multiple numbers). The returned list is every
result where the function being applied is `id` and every result where the
function being applied is `negate`.

Apply works with functions of more than one argument.
```
> Just (+) <*> Just 1 <*> Just 1
Just 2
```
-->
