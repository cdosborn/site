If you&rsquo;re familiar with git, you&rsquo;re aware of several problems it solves for
projects. Git allows you to make snapshots, backup your work to a remote, and
collaborate by synchronizing others&rsquo; changes.

As a thought experiment, consider how git compares to Google Docs. It also
performs snapshots and backups, and enables collaboration (without merge conflicts!).

The difference lies in the history.

With git you must intentionally make snapshots and document each one. This
isn't automated. The leverage you gain from using a tool like git is the
ability to shape the history.

### Git fundamentals

The commit is the building block of the history. It stores a descriptive
message and a snapshot of the project. Due to the nature of how commits are
made on the command line, it's natural to think that each commit stores some
changes, this is a false intuition. Each commit is a picture of all the files
at a given time.

In git, you're building a graph out of commits. Git doesn't have
any real notion of branches. There are just commits with parents. In this
graph each commit has at most a single parent.

    o---o---o---o---o  master
         \
          o---o---o---o---o  next
                           \
                            o---o---o  topic

In this graph, `master` points to a commit with two parents. This type of
commit is referred to as a merge. It still contains a snapshot of all the
files like a regular commit.

    o---o---o---o---o-------o master
         \                 /
          o---o---o---o---o  next

### What does a rich history look like?

Git supports two levels of detail: the branch and the commit. The commit is
the building block of the history. It boils down to a commit message and a
changeset. The branch, a string of these commits, represents a feature.

### The commit changeset

A commit&rsquo;s changeset should be as small as possible but no smaller. Sometimes
it should be a single line, sometimes multiple lines spanning several files.

If you&rsquo;re fixing a typo, make a commit for that single change. A reviewer will
miss it in the sea of other changes.

If you&rsquo;re renaming a method&rsquo;s paramater, a commit should include the changes
to all affected files. Though, you wouldn&rsquo;t want to combine this rename with a
refactor of the method as well.

If you&rsquo;re fixing a bug, it&rsquo;s okay if the change spans multiple
files. If all the changes are contained in a single commit, it will be easier
to move or cherry-pick elsewhere. Resist the urge to make other changes while
fixing the bug.

### The commit message

The other aspect to a commit is the message. I like the suggestion by Tim Pope
to include a summary line followed by a blank line followed by further
explanation
<code>[[link]](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)</code>.

Good commit messages are thorough and concise. I try to keep mine to a few
lines, but sometimes write more.

Many commit messages do not provide enough context. Sometimes the message will
describe exactly what the code does. However, the changeset already includes
this information. Someone looking back will want to know the _why_ behind the
change.

A good rule of thumb when fixing bugs: separate the body of your message into
a problem and solution statement. This is a helpful practice, because it
forces you to clearly state your problem.

### The ideal branch

Each branch should have a theme. If you have a feature that is naturally
broken into several steps, you can represent each step with a commit. If
someone were curious about a particular change, they could look at the branch
where it was introduced to get the big picture.

When you&rsquo;re working on a new branch you will not know what final set of
commits is right. I suggest not worrying about it until you are happy with the
sum of your changes. At this point you can review your commits.

If you made a mistake in a commit, you can just rewrite it to never have
happened. If any of your commits have poor formatting or break the tests, you
can rewrite these too.

### Prefer a linear history

While you're working on a feature, opportunities will arise where you want to
incorporate other work. Maybe you were working off of master, and since then
several new commits went into master that you want. Maybe someone
contributed commits which fixed early issues in your feature.

There are only two ways to incorporate other work. You can join the other work
and your feature via a merge commit, or you can move your work on top of
theirs.


Merges can also can be misleading. Commits do not actually store changes. They
store an entire snapshot of the project! If you have used `git log -p` to view
commits&rsquo; &ldquo;changes&rdquo;, you're viewing the comparison between
each commit and its parent. However, a merge has multiple parents. Its
snapshot could have work from either parent, or be entirely new. You may
expect a merge to only join histories when instead it adds new content.

Merges detract from the simplicity of your feature. Since they are optional
and can always be rewritten in a linear way.

### The benefits of rich history

The history is important in two particular instances: code review and later on
when someone is seeking answers.

A better history makes for easier code review. Reviewers can walk through your
changes one commit at a time. In some ways it's like a tutorial. You read the
commit message, inspect the change and move to the next. Normally it&rsquo;s
_not_ worthwhile to review a feature this way. You may try to understand a
commit only to find that it is undone later. You may find a bug in a commit,
and then need to keep track of it to see if it&rsquo;s fixed later. Reviewers
tend to give up on this approach and prefer instead to make sense of all the
changes at once. From my experience this is sub-optimal. You can enable a
simpler way to review your work by giving attention to the history of your
feature.

Often the history is the only place you can get an answer. The original author
may no longer be on the team, or they may simply not remember. When the commit
message, author, timestamp, and containing branch are taken into
consideration, a lot can be pieced together about a particular change.

### Is caring about the history worthwhile?

It takes time to write clear commit messages. However, as the author,
you&rsquo;re the most capable. Also, investing your time offloads the work
from your reviewer and peers onto yourself, which everyone will appreciate.

The other major cost is the git knowhow required to rewrite and shape history. Some
teams squash every feature into a single commit before it is incorporated.
This tradeoff sacrifices context, but makes it easier to contribute.

I don&rsquo;t think there's a one-size-fits-all solution. It is at least worthwhile
to think in terms of building a rich history when working with git.
