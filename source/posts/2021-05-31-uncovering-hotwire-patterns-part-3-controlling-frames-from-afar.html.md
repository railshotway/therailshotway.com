---
title: 'Uncovering Hotwire Patterns Part 3: Controlling Frames From Afar (Turbo Frames + Forms = ❤️)'
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

In the last <a href="/posts/2021/05/29/uncovering-hotwire-patterns-part-1-loading-frames-on-demand.html" target="_blank">two</a>
<a href="/posts/2021/05/29/uncovering-hotwire-patterns-part-2-separating-concerns.html" target="_blank">posts</a>,
we've been replicating HEY's menu in a fake email service called _**YO!**_
But we've only ever written about fetching its content. Today, let's consider the menu's interactive elements.

## Context

Here's the form in action:

<img class="img--centered" src="https://www.dropbox.com/s/3nedyzkipdlks1t/yo-menu-demo.gif?raw=1" alt="Gif showing our replica of the HEY menu" width="600" height="325" />

You can find the source code in <a href="https://github.com/JoseFarias/yo-email" target="_blank">this GitHub repo</a>.

And here are some interesting behaviors of this form:

**Things we'll be exploring today:**

1. It displays results within a Turbo Frame that could be anywhere on the current page
1. It leverages ARIA attributes to query the DOM
1. It filters product sections (`Favorites`, `Library`, `Receipts`, etc.) and contacts simultaneously
1. It displays an empty state when no results are found

**Things I am not considering exploring, but you can look at in <a href="https://github.com/JoseFarias/yo-email" target="_blank">the repo</a>:**

1. Its value is submitted automatically as you type
1. Submission is debounced (only submitted every couple of milliseconds, to avoid firing too frequently)
1. It has some other small nicities like clearing its contents with the `esc` key and suppressing validation errors when they're not relevant

_Reach out on_ <a href="https://twitter.com/fariastweets" target="_blank">_Twitter_</a> _if you'd like me to cover these._

## An Implementation

Here's the code for the above GIF. An implementation breakdown is available after the code blocks.


<meta data-controller="callout" data-callout-text-value="&quot;contacts&quot;">
<meta data-controller="callout" data-callout-text-value="&quot;navigation_results&quot;" data-callout-type-value="blue">

```html
<!-- navigation.html -->

<turbo-frame id="my_navigation">
  <div class="container">
    <div class="row">
      <form data-controller="form"
            data-action="input->form#debouncedSubmit"
            data-turbo-frame="contacts"
            action="/contacts">
        <label>
          <input type="text"
                 role="combobox"
                 aria-controls="navigation_results"
                 placeholder="Type to search…"
                 name="q"
                 data-controller="filter"
                 data-filter-attribute-value="data-name"
                 data-filter-empty-value="navigation_results_empty"
                 data-filter-empty-class="popup-picker--empty"
                 data-action="invalid->form#suppressValidationMessage
                              keydown->form#resetByKeyboard
                              input->filter#query">
          <span class="material-icons-round">
            filter_list
          </span>
        </label>
      </form>
    </div>

    <div id="navigation_results">
      <section role="presentation" class="row popup-picker__show-when-empty">
        <span id="contacts_empty" class="search-result">
          <span>No matches found</span>
        </span>
      </section>

      <!--
        Buttons for product sections (`Favorites`, `Library`, `Receipts`, etc.)
        would go here. Omitted for this example.
       -->

      <div class="row">
        <turbo-frame id="contacts"></turbo-frame>
      </div>
    </div>
  </div>
</turbo-frame>
```
<meta data-controller="callout" data-callout-text-value="&quot;aria-controls&quot;" data-callout-type-value="blue">

```js
// form_controller.js

export default class extends Controller {
  static classes = ["empty"]
  static values = { attribute: String, empty: String }

  initialize() {
    const observeOptions = { childList: true, subtree: true, attributes: true }
    // NOTE: Sometimes the server will respond after .filterOptions is called,
    //  This calls it again after the frame within listboxElement changes.
    this.observeMutations(this.filterOptions, this.listboxElement, observeOptions)
  }

  connect() {
    this.comboboxElement.setAttribute("aria-autocomplete", "list")
    this.comboboxElement.setAttribute("aria-haspopup", "listbox")
    this.listboxElement.setAttribute("role", "listbox")
  }

  query() {
    this.filterOptions()
  }

  // Private

  observeMutations(callback, target, options) {
    const observer = new MutationObserver(mutations => {
      observer.disconnect()
      Promise.resolve().then(start)
      callback.call(this, mutations)
    })
    function start() {
      if (target.isConnected) {
        observer.observe(target, options)
      }
    }
    start()
  }

  filterOptions() {
    const query = this.comboboxElement.value.trim()

    this.optionElements.forEach(applyFilter(query, { matching: this.attributeValue }))

    if (this.hasEmptyClass) {
      this.listboxElement.classList.toggle(this.emptyClass, this.isEmpty)
    }

    if (this.hasEmptyValue) {
      const update = this.isEmpty ? addToken : removeToken // see html_helpers.js
      const tokens = this.comboboxElement.getAttribute("aria-describedby")

      this.comboboxElement.setAttribute("aria-describedby", update(tokens, this.emptyValue))
    }
  }

  get comboboxElement() {
    return this.element.querySelector("input[role=combobox]") || this.element
  }

  get listboxElement() {
    const listbox = this.comboboxElement.getAttribute("aria-controls")

    return document.getElementById(listbox)
  }

  get optionElements() {
    return this.listboxElement.querySelectorAll(`[${this.attributeValue}]`)
  }

  get isEmpty() {
    return [ ...this.optionElements ].filter(visible).length == 0
  }
}

function applyFilter(query, { matching }) {
  return (target) => {
    if (query) {
      const value = target.getAttribute(matching) || ""
      const match = value.toLowerCase().includes(query.toLowerCase())

      target.hidden = !match
    } else {
      target.hidden = false
    }
  }
}
```

```js
// html_helpers.js

export function createTokenList(string) {
  const element = document.createElement("div")
  element.className = string || ""
  return element.classList
}

export function removeToken(string, token) {
  const tokenList = createTokenList(string)
  tokenList.remove(token)
  return tokenList.toString()
}

export function addToken(string, token) {
  const tokenList = createTokenList(string)
  tokenList.add(token)
  return tokenList.toString()
}

```

```css
/* styles.scss */

.popup-picker--empty > * {
  display: none
}

.popup-picker--empty .popup-picker__show-when-empty {
  display: block
}

.popup-picker__show-when-empty {
  display: none
}
```

This is a simplified version of the code from the gif above. I mostly omitted
CSS classes and other distracting attributes to make things cleaner. If you're looking for a 100% functioning
implementation check out the <a href="https://github.com/JoseFarias/yo-email" target="_blank">GitHub repo</a>.

## Implementation Breakdown

Here's how the implementation does each of the items on the list at the start of this article

## It displays results within a Turbo Frame that could be anywhere on the current page

Add a `data-turbo-frame` attribute to the `<form>` element containing the `id` of the frame you'd like the response to be rendered in.

That's it! Gotta love that Hotwire simplicty.

## It leverages ARIA attributes to query the DOM

Consider the following snippet:

```js
get listboxElement() {
  const listbox = this.comboboxElement.getAttribute("aria-controls")

  return document.getElementById(listbox)
}
```

How beautiful is that? Leveraging HTML semantics lets us have better accessibility AND
cleaner code.

Here's a quick summary of how to use [aria-controls](https://www.digitala11y.com/aria-controls-properties/)

TODO: Talk about getAttribute("aria-describedby")

## It filters product sections (`Favorites`, `Library`, `Receipts`, etc.) and contacts simultaneously


## It displays an empty state when no results are found

## The Pattern


