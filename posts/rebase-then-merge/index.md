_This is a niche technical post on the software development tool [git](https://git-scm.com/)._

When you need to incorporate commits into your branch, you can perform a merge
or you can perform a rebase. In a rebase, you're constructing a new branch
with your commits appended to the end. By appending, you're left with a longer
strand of commits. When you merge, the two histories are kept distinct.

In this post, I'll argue why you should only create "logical" merge
commits--merge commits that introduce no new changes, but join branches
together.

Suppose you're tasked with incorporating both these features into `master`.

              o---o  feature-a
             /
    o---o---o---o---o  master
         \
          o---o---o  feature-b


In a rebase and merge approach, you take `feature-a` rebase (move the base of it)
to `master`.

                      o---o  feature-a
                     /
    o---o---o---o---o  master


Now its possible that this move will require some manual intervention. The
rebase operation reconstructs the branch a commit at a time. Suppose we have
`A` the first commit of `feature-a`. How does git construct `A'` this first
migrated commit?

               A       A'
              o       o
             /       /
    o---o---o---o---o  master


Git first looks at `C` the common ancestor of `A` and `master`, the last
commit each had in common. Then Git compares all `A`'s changes and all
`master`'s changes since `C`.

               A
              o
             /
    o---o---o---o---o  master
           C

If the `C` to `A` changes overlap with the `C` to `master` changes, then Git
considers those changes conflicting.

If you resolve the conflicts and continue the rebase, git will have
reconstructed the commit at the new location.

               A       A'
              o       o
             /       /
    o---o---o---o---o  master


Git repeats this process for each additional commit. In order to bring over
commit `B` on top of `A'`, Git will identify their common ancestor then see if
the changes from `C` to `B` overlap with the changes from `C` to `A'`.


                   B   A'
              o---o   o
             /       /
    o---o---o---o---o  master
           C

If the changes do not overlap, then a new commit is created containing both
sets of changes.


                   B       B'
              o---o   o---o
             /       /
    o---o---o---o---o  master

After the rebase of `feature-a`, you'll want to merge this into `master`. When
you perform this merge, Git will by default not create a merge commit. It will
perform a fast-forward merge resulting in the following graph.

                      o---o  feature-a, master
                     /
    o---o---o---o---o

You can instruct git to create the commit (see `--no-ff`)
<a style="text-decoration:none" id="fn:1" href="#fn:1:defn"><sup>1</sup></a>.
In either approach, master will contain the same changes. However,
constructing the merge commit preserves the history of the branch in the graph
itself. For example, in the above graph `master` records no history of a
feature distinct from its own history, whereas that information is captured
below.


                      o---o feature-a
                     /     \
    o---o---o---o---o-------o  master


If you repeat this process for `feature-b` you should expect a graph like so:

                      o---o feature-a
                     /     \
    o---o---o---o---o-------o-----------o master
                             \         /
                              o---o---o feature-b

Following this pattern for all work will produce a `master` that is just a
series of merge commits. I've seen this pattern used where each feature is
squashed into a single commit prior to merge--this makes sense when the
commits are not particularly useful.

Most importantly, work is never introduced into the merge commits. Each merge
commit should be identical to the last commit of the feature, except that it
has two parents. If you want to copy a feature, you just copy the commits
of the feature.

Otherwise, a merge commit tends to resolve all the conflicts at once between
two branches. This can be error prone--leading to new work being added, or
existing work accidentally omitted.

It's possible to use merges only to indicate logical changes (defining when a
branch ends) and leave the rest to rebase.

<div class="footnotes">
<p>
    <a id="fn:1:defn">1.</a>
    You can change git's default behavior, so that merge commits are always
    created, with this entry in your <code>~/.gitconfig</code>
    <pre><code>[merge]
      ff = false</pre></code>
    <a href="#fn:1">↩</a>
</p>
</div>
