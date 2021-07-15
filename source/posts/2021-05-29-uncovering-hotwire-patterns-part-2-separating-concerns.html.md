---
title: 'Uncovering Hotwire Patterns Part 2: Separating Concerns'
series: uncovering_hotwire_patterns
author: jose_farias
date: 2021-05-29 12:30 UTC
tags:
  - Hotwire
  - Basecamp
  - Hey
---

_Hotwire is a new technology built on top of mature web principles. Its "oldness" makes it reliable. And its "newness" makes it applicable to modern demands._

_This is a series about uncovering patterns for Hotwire by taking a look at how successful companies are using it in production._

---

<a href="/posts/2021/05/29/uncovering-hotwire-patterns-part-1-loading-frames-on-demand.html" target="blank">Last time</a>,
we talked about one of the benefits of separating concerns by leveraging Turbo Frames.
Today, I'm writing about the actual separation of concerns.

This is going to be a post about a thought pattern, rather than a code pattern.
And how following web standards allows for quick and easy implementations of
the subject matter.

## Context

HTML can get very messy, very quick. That's one of the reasons abstractions such as
<a href="https://haml.info/" target="_blank">Haml</a>,
<a href="https://pugjs.org/" target="_blank">Pug</a>, and
<a href="http://slim-lang.com/" target="_blank">Slim</a> emerge.
But HTML can actually be beautiful and easy to read if we keep our
markup **semantic** and **short**.

Rails allows for that to some extent through modest use of layouts and partials.
However, that approach can result in mixing in too many concerns.
We can take things further by leveraging Hotwire.

We usually picture database-backed models when we talk about REST resources.
But let's consider the posibility of our UI components also being resources.
This would allow us to separate complex UI elements into their own concerns within
our code and use Turbo Frames to load each element where appropriate. This is preferable
to rendering complex markup inline for a single HTTP request (typically through the use of partials),
as it keeps our code cleaner.

Today's pattern takes advantage of things simply falling into place when web standards
are followed. In this case, following REST guidelines makes it easy to reason
about our application. Which, in turn, makes it easy to connect and maintain
multiple components.

## An Implementation
In <a href="https://hey.com" target="_blank">HEY</a>, menus and trays have their own
RESTful URLs. This is what it looks like if we navigate to, say, `https://app.hey.com/my/navigation`:

<img class="img--centered" src="https://www.dropbox.com/s/0ehjy7h3q3n7jm0/my-navigation.png?raw=1" alt="Image showing the HEY menu navigation by itself, rendered across the full-width of the screen" />

We usually only see the HEY menu confined to a small box positioned just below the navbar.
But we can absolutely navigate to this full-width version of the menu, because it's a resource.

Here are some other routes we typically only encounter within Turbo Frames:

* `/me`
* `/set_aside/tray`
* `/reply_later/tray`
* `/postings/<posting_id_just_the_number)>/note/edit` (Posting ids can be found by inspecting the row of one of your emails, look for `<article>` elements)

Try navigating to them and see what they look like for you!

We know from <a href="https://www.jorgemanrubia.com/" target="_blank">Jorge Manrubia</a>'s talk
about <a href="https://youtu.be/GdXOXncUB9M?t=2499" target="_blank">fighting the merchants of complexity</a>
that Basecamp does appear to think of these menus are REST resources. For example,
the `Me` menu has its own controller that looks something like:

```ruby
class MeController < ApplicationController
  def show
    # Code goes here
  end
end
```

That is to say, `Me` is something that can be instantiated and shown to users.
And what does a `Me` look like? Well, it looks like a `Me` _menu_, of course!

## The Pattern
Again, this is more of a thought pattern. An invitation of sorts to think about
our application as a combination of REST resources. And we're not only talking
about our database-connected models. We're talking about our UI components as well.

By doing this, we're able to keep the surface area of our domain components small.

In <a href="/posts/2021/05/29/uncovering-hotwire-patterns-part-1-loading-frames-on-demand.html" target="blank">last post</a>'s example,
we replicated the HEY menu in a fake email service called _**YO!**_
(code available at <a href="https://github.com/JoseFarias/yo-email" target="_blank">this GitHub repo</a>).
Here's that that looked like:

<img class="img--centered" src="https://www.dropbox.com/s/3nedyzkipdlks1t/yo-menu-demo.gif?raw=1" alt="Gif showing our replica of the HEY menu" />

This menu contains a search form that can be kind of complex. It has its own rules
of engagement. It fetches records and displays them in an entirely different frame
(this is a pattern we'll talk about in a future post). It's _its own thing_. And,
as such, it shouldn't be bundled with the rest of the navigation. Not even within partials.

Components like this one should have their own place to live.
They deserve their own controller. Or at least their own action within an existing controller.
With Hotwire, we can give them that place to live and load them asynchronously
<a href="/posts/2021/05/29/uncovering-hotwire-patterns-part-1-loading-frames-on-demand.html" target="_blank">as needed</a>.

_Contextual side-note: This is not a new concept. The Rails community has been doing this for a while. But Hotwire makes it super easy to implement._

One last thing to remember is the importance of flexibility. It doesn't always make
sense to force a component into a REST resource. We must make sensible choices that
result in our application being easier to reason about. Let's not follow guidelines blindly.

## Wrap Up

Thinking of our application (UI included) as a combination of REST resources
makes it easy to reason about, easy to navigate, and easy to maintain.

Hotwire makes it a breeze to connect different parts of our application when
architecting our domain in this way.

I'm going to keep extracting patterns from apps like HEY in upcoming posts.
So follow me on <a href="https://twitter.com/fariastweets" target="_blank">Twitter</a> to stay tuned!

## Comments

We're only just setting up this blog and don't have plans for a comments section yet.
But feel free to reach out on <a href="https://twitter.com/fariastweets" target="_blank">Twitter</a>.
