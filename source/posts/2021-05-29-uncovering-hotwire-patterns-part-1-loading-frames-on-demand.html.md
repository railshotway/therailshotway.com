---
title: 'Uncovering Hotwire Patterns Part 1: Loading Frames On-Demand'
series: uncovering_hotwire_patterns
author: jose_farias
date: 2021-05-29 12:00 UTC
tags:
  - Hotwire
  - Basecamp
  - Hey
---

_Hotwire is a new technology built on top of mature web principles. Its "oldness" makes it reliable. And its "newness" makes it applicable to modern demands._

_This is a series about uncovering patterns for Hotwire by taking a look at how large companies are using it in production._

---

One way we can use turbo frames that's not immediately obvious is separating concerns.

This has several benefits, such as:

* Keeping our architecture clean
* Making our HTML easier to read
* Making our app easier to cache
* Loading things only when we need them

That last point is going to be the focus of this post. We might touch on the
others in future posts.

## Context

From the <a href="https://turbo.hotwire.dev/handbook/frames#lazily-loading-frames" target="_blank">Hotwire docs</a>,
we know introducing `<turbo-frame>` elements with `src` attributes is enough
to lazy-load the frame's contents when the site is visited.

But what if we don't want to load the frame's contents immediately? A couple reasons that might be:

* Our frame will contain information that is only available after a user takes a certain action
* Our frame is hidden away inside a menu or a modal and we want to avoid unnecessary server hits
* We want to leverage existing patterns in our application

In these cases we'd want to **load frames on-demand**. We can do this in multiple ways.

It turns out <a href="/posts/2021/04/17/turbo-file-browser.html" target="_blank">we only need to change the `src` attribute</a>
of a `<turbo-frame>` to make it navigate to a certain page.
So, technically, we can start with an empty `<turbo-frame>` with no `src`
attribute and then use JavaScript to change its `src` programmatically.

This is effective and quick. And we might want to go that route for involved
implementations of this pattern. But <a href="https://hey.com" target="_blank">HEY</a>'s
source code gives us a more elegant way of doing this when the frame is "hidden"
behind other interactive elements, such as a menu. Here's what that looks like:

<img class="img--centered" src="https://www.dropbox.com/s/73ifu7y88y8l3qe/HEY-menu-on-click-demo.gif?raw=1" alt="Gif showing the HEY menu loading a Turbo Frame on-demand" width="600" height="256" />

Notice how the `<turbo-frame>` was initially empty:

<img class="img--centered" src="https://www.dropbox.com/s/6gonlv0ee587x7z/HEY-menu-empty-frame.png?raw=1" alt="Gif showing the HEY menu loading a Turbo Frame on-demand" width="612" height="60" />

And was populated only after clicking on the menu button:

<img class="img--centered" src="https://www.dropbox.com/s/uv80ohcd0mu90ll/HEY-meny-populated-frame.png?raw=1" alt="Gif showing the HEY menu loading a Turbo Frame on-demand" width="613" height="119" />

For the next couple of entries in this series, we're going to be replicating the
HEY menu in a fake email service called _**YO!**_ This is the end result:

<img class="img--centered" src="https://www.dropbox.com/s/3nedyzkipdlks1t/yo-menu-demo.gif?raw=1" alt="Gif showing our replica of the HEY menu" width="600" height="325" />

I suggest using the featured approach instead of changing the frame's `src` with
pure JavaScript. Here's why:

* It gives us a reusable Stimulus controller so we can replicate this behavior on other parts of our app using HTML alone.
* It makes each element's purpose evident directly from the HTML.
* It allows our site to still work without JavaScript. Albeit with a poorer user experience.

---
**Note:**

_Basecamp was recently_ <a href="https://www.platformer.news/p/-what-really-happened-at-basecamp" target="_blank">_embroiled in controversy_</a>. _This post takes a look inside the hood of HEY, a product of Basecamp, in admiration of the commendable work done by current and former employees of the company. We'd like to keep these people and their work as the focus we're admiring here._

---

## An Implementation

We're going to be implementing the functionality shown in the above GIF
(just the loading frames on-demand part. Filters will be covered in a future post).
Here's a refresher of what it's going to look like:

<img class="img--centered" src="https://www.dropbox.com/s/3nedyzkipdlks1t/yo-menu-demo.gif?raw=1" alt="Gif showing our replica of the HEY menu" width="600" height="325" />

I emailed Basecamp about this, by the way. they're okay with you and I building a HEY
clone for educational purposes.

Here's a working implementation of the above GIF. Note that serving a `/navigation`
route is necessary to actually populate the frame (<a href="https://github.com/JoseFarias/yo-email/blob/0a10338a53341312cc469fed8ddfd91ec30fd86e/src/server/views/navigation.html" target="_blank">see repo</a>).
An implementation breakdown is available after the code blocks.

<meta data-controller="callout" data-callout-text-value="summary">
<meta data-controller="callout" data-callout-text-value="my_navigation" data-callout-type-value="blue">
<meta data-controller="callout" data-callout-text-value="link" data-callout-type-value="pink">

```html
<!-- views/index.html -->

<nav class="container"
     aria-label="Main">
  <div class="row">
    <div class="col-12">
      <details data-controller="popup-menu"
               data-action="toggle->popup-menu#update">
        <summary aria-label="Go to">
          <span>&#9996;</span> <!-- Wave emoji -->
          <span>YO!</span>
          <span class="material-icons-round"
                data-popup-menu-target="arrow">
                expand_more
          </span>

          <a href="/navigation"
             data-turbo-frame="my_navigation"
             data-popup-menu-target="link">
              YO!
          </a>
        </summary>

        <turbo-frame id="my_navigation"
                     target="_top"
                     role="menu">
          <span class="u-for-screen-reader" role="menuitem" aria-disabled="true">Loading</span>

          <!-- Loader from https://loading.io/css/ -->
          <div class="loader">
            <div class="lds-ellipsis"><div></div><div></div><div></div><div></div></div>
          </div>
        </turbo-frame>
      </details>
    </div>
  </div>
</nav>
```

<meta data-controller="callout" data-callout-text-value="summaryElement">
<meta data-controller="callout" data-callout-text-value="&quot;summary&quot;">
<meta data-controller="callout" data-callout-text-value="&quot;data-turbo-frame&quot;" data-callout-type-value="blue">
<meta data-controller="callout" data-callout-text-value="&quot;link&quot;" data-callout-type-value="pink">
<meta data-controller="callout" data-callout-text-value="linkTarget" data-callout-type-value="pink">
<meta data-controller="callout" data-callout-text-value="frameElement" data-callout-type-value="green">

```js
// js/controllers/popup_menu_controller.js

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["arrow", "link"]

  initialize() {
    if (this.hasLinkTarget) {
      this.linkTarget.hidden = true
    }
  }

  connect() {
    this.summaryElement?.setAttribute("aria-haspopup", "menu")
    this.update()
  }

  disconnect() {
    this.close()
  }

  async update() {
    this.arrowTarget.innerHTML = "expand_more"

    if (!this.element.open) {
      return
    }

    if (this.hasLinkTarget) {
      this.linkTarget.click()
    }

    if (this.frameElement) {
      await this.frameElement.loaded
    }

    this.summaryElement?.setAttribute("aria-expanded", this.element.open)
    this.arrowTarget.innerHTML = "expand_less"
  }

  close() {
    this.element.open = false
  }

  // Private

  get summaryElement() {
    return this.element.querySelector("summary")
  }

  get frameElement() {
    const id = this.hasLinkTarget &&
               this.linkTarget.getAttribute("data-turbo-frame")

    return id && document.getElementById(id)
  }
}
```

This is a simplified version of the code from the gif above. I mostly omitted
CSS classes and other distracting attributes to make things cleaner. If you're looking for a 100% functioning
implementation check out the <a href="https://github.com/JoseFarias/yo-email" target="_blank">GitHub repo</a>.

## Implementation Breakdown

This can be broken down into:

**Markup:**

1. Have an interactive element (in this case `<details>`)
1. Connect it to the _Popup Menu_ Stimulus controller
1. Have the element call `#update` when interacted with
1. Have the element contain an `<a>` tag with `href` and `data-turbo-frame` attributes
1. Connect the `<a>` tag with the Stimulus controller via `data-popup-menu-target="link"`

**Interactivity:**

1. Have a Stimulus controller hide the `<a>` tag on init, we won't need it if Stimulus is running (which means JS is enabled)
1. When `#update` is called, simulate a click on the hidden `<a>` tag
1. Use `await` to halt execution until the promise returned by the frame's `#loaded` method is resolved
1. Execute any side effects that happen after content is loaded (in our case, flipping the menu's arrow indicator)
1. Add/modify aria labels throughout, when appropriate


Notice how using appropriate HTML semantics makes it easy to query and manipulate the DOM.
In this case, HEY uses a `<summary>` tag within a `<details>` element where other
implementations might opt for nested `<div>`s (which would be semantically incorrect).
We'll see other examples of this using `aria` attributes in a later post.

## The Pattern

Here's an attempt to abstract our implementation into a reusable pattern using HTML and StimulusJS.

<meta data-controller="callout" data-callout-text-value="data-controller=&quot;popup-menu&quot;">
<meta data-controller="callout" data-callout-text-value="my-frame" data-callout-type-value="blue">
<meta data-controller="callout" data-callout-text-value="link" data-callout-type-value="pink">

```html
<!--
  We're using a `<details>` element inside a `<nav>` here.
  But this would work with any element that
    1. Connects to the appropriate Stimulus controller
    2. Calls #update when interacted with
    3. Contains an `<a>` tag with `href` and `data-turbo-frame` attributes
    4. Makes the `<a>` tag a "link" target for the Stimulus controller

  Note that the `href` attribute should point to a page that contains a
  `<turbo-frame>` with a matching `id` to the one on this page.
-->
<nav>
  <details data-controller="popup-menu" data-action="toggle->popup-menu#update">
    <summary>
      <span>Markup for our interface goes here</span>

      <a href="/frame-content" data-turbo-frame="my-frame" data-popup-menu-target="link">
        Link hidden by Stimulus controller
      </a>
    </summary>
  </details>
</nav>

<!--
  This frame id *has* to match the `data-turbo-frame` value in the `<a>` tag.

  This frame would usually
    1. Be hidden by default
    2. Be shown when the Stimulus controller's element is interacted with
    3. Contain a loading state to be displayed while the frame loads

  Note that this frame can be located anywhere on the current page.
-->
<turbo-frame id="my-frame">
  Initial state.
</turbo-frame>
```

<meta data-controller="callout" data-callout-text-value="&quot;data-turbo-frame&quot;" data-callout-type-value="blue">
<meta data-controller="callout" data-callout-text-value="&quot;link&quot;" data-callout-type-value="pink">
<meta data-controller="callout" data-callout-text-value="linkTarget" data-callout-type-value="pink">
<meta data-controller="callout" data-callout-text-value="frameElement" data-callout-type-value="green">

```js
// js/controllers/popup_menu_controller.js

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["link"]

  initialize() {
    if (this.hasLinkTarget) {
      this.linkTarget.hidden = true
    }
  }

  connect() {
    this.update()
  }

  disconnect() {
    this.close()
  }

  async update() {
    // `.isActive` is pseudo-code. Make this into a guard-clause to avoid misfires.
    if (!this.element.isActive) {
      return
    }

    if (this.hasLinkTarget) {
      this.linkTarget.click()
    }

    if (this.frameElement) {
      await this.frameElement.loaded
    }
  }

  close() {
    // `isActive` is pseudo-code. Disable the element in some way to avoid misfires.
    this.element.isActive = false
  }

  // Private

  get frameElement() {
    const id = this.hasLinkTarget &&
               this.linkTarget.getAttribute("data-turbo-frame")

    return id && document.getElementById(id)
  }
}
```

## Wrap up
We don't always want our frames to load immediately. And this Markup + Stimulus combo
gives us an elegant, reusable mechanism to load frames on-demand to avoid unnecessary
server hits, among other benefits.

I'm going to keep extracting patterns from apps like HEY in upcoming posts.
So follow me on <a href="https://twitter.com/fariastweets" target="_blank">Twitter</a> to stay tuned!

## Comments

We're only just setting up this blog and don't have plans for a comments section yet.
But feel free to reach out on <a href="https://twitter.com/fariastweets" target="_blank">Twitter</a>.
