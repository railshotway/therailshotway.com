---
title: 'Uncovering Hotwire Patterns Part 3: Controlling Frames From Afar (Turboframes + Forms = ❤️)'
series: uncovering_hotwire_patterns
author: jose_farias
published: false
date: 2021-05-31 12:00 UTC
tags:
  - Hotwire
  - Basecamp
  - Hey
---

_Hotwire is a new technology built on top of mature web principles. Its "oldness" makes it reliable. And its "newness" makes it applicable to modern demands._

_This is a series about uncovering patterns for Hotwire by taking a look at how large companies are using it in production._

---

In the last two posts, we've been playing around with replicating HEY's menu in
a fake email service called _**YO!**_. But we've only ever talked about fetching
its content. Today, let's talk about the menu's search form.

## Context

Here's the form in action:

<img class="img--centered" src="https://www.dropbox.com/s/3nedyzkipdlks1t/yo-menu-demo.gif?raw=1" alt="Gif showing our replica of the HEY menu" width="600" height="325" />

You can find the source code in <a href="https://github.com/JoseFarias/yo-email" target="_blank">this GitHub repo</a>.

And here are some interesting behaviors of this form:

**Things we'll be exploring today:**

1. It displays results within a Turbo Frame that could be anywhere in the current page
1. It leverages ARIA attributes to query the DOM

**Things we'll explore on the next post**
1. It filters product sections (`Favorites`, `Library`, `Receipts`, etc.) and contacts simultaneously
1. It displays an empty state when no results are found

**Things I am not considering exploring, but you can look at in the repo:**
_Note: Reach out on_ <a href="https://twitter.com/fariastweets" target="_blank">_Twitter_</a> _if you'd like me to cover these._

1. Its value is submitted automatically as you type
1. Submission is debounced (only submitted every couple of milliseconds, to avoid firing too frequently)
1. It has some other small nicities like clearing its contents with the `esc` key and suppressing validation errors when they're not relevant

## The Pattern(s?)


