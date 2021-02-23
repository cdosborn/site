In the past few months I worked for a client and managed a small project with their
in-house development team.

In August, I wrote a blog post [Rebase then
merge](/posts/rebase-then-merge.html) which outlined a specific approach for
managing different branches of work. I had the opportunity to test this
approach with this team. I found that it had some positive
effects.

A common practice is that a developer merges the main branch into their
feature branch. They may do this several times and then push the resulting
branch to be reviewed. This can be error prone, because a developer may run
into conflicts and resolve them in a problemmatic way. A less experienced
developer may remove work made by others. To counteract this, a reviewer needs
to inspect every merge to make sure that this doesn't happen. This is pretty
inconvenient.

In the suggested approach, a new developer is retrieving the latest main
branch, rebasing their commits on top. Their work is always a set of changes
on top of the latest work. The developer will have to resolve conflicts but
these resolved conflicts are not hidden in merge commits. Each change made by
the developer will appear in a non-merge commit.

Logically this approach makes a bit more sense. Every commit is a snapshot of
the entire project. This is true for merge and non-merge commits. Each
non-merge commit has a single parent, and if you compare the parent (older
snapshot) with the child (newer snapshot) you can think of the child snapshot
as representing changes to the older snapshot. String a few of these commits
together and you have a series of changes. This is the model most people think
of when they use git.

However, a merge commit cannot be thought of in this way. It has two parents
and so the child can be compared to either parent. Each comparison would
produce a separate set of changes. So a merge cannot be thought of as a set of
changes, it's just an arbitrary snapshot. There is no requirement that a
change in the child come from either parent.

The approach is all about eliminating these potentially problemmatic merge
commits. While there was some upfront costs in the team switching to rebase,
the git contributions became easier to reason about. I think the tradeoff is
worthwhile. As soon as a few developers start regularly contributing it's
otherwise too easy for developers to accidentally step on each others'
contributions.

[https://www.toptal.com/git](https://www.toptal.com/git)
